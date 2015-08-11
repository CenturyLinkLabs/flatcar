module Flatcar
  class Project
    attr_accessor :name, :database, :webapp, :options

    def self.init(options, args)
      project = new(options, args)
      project.write_dockerfile
      project.write_compose_yaml
      project.build
    end

    def initialize(options, args)
      @args = args
      @name = project_name
      @database = Flatcar::Service.instance(options.delete(:d))
      @webapp = Flatcar::Service.instance('webapp', base_image: options.delete(:b), database: @database)
      @options = options
      fs_init
    end

    def app_path
      @args.empty? ? '.' : @args[0]
    end

    def project_path
      path = Dir.pwd
      unless app_path == '.'
        path = path + "/#{name}"
      end
      path
    end

    def project_name
      if @args.empty?
        File.basename(Dir.pwd)
      else
        @args[0]
      end
    end

    def write_dockerfile
      puts "MAKIN' THAT DOCKER THING!"

      dockerfile = @webapp.dockerfile
      File.open("#{app_path}/Dockerfile", 'w') { |file| file.write(dockerfile) }
    end

    def write_compose_yaml
      compose_yaml =
        [
          @webapp.compose_block,
          (@database.compose_block if @database)
        ].join("\n")
      File.open("#{app_path}/docker-compose.yml", 'w') { |file| file.write(compose_yaml) }
    end

    def get_binding
      binding()
    end

    def build
      puts "cd #{app_path}/ && docker-compose build"
      system("cd #{app_path}/ && docker-compose build")
    end

    private

    def fs_init
      system(rails_new)
    end

    def rails_new
      rails_new = "rails new -B #{app_path}"
      rails_new << " -d #{@database.name}" if @database
      rails_new << ' --skip-javascript' if @options['skip-javascript']
      rails_new << ' --skip-git' if @options['skip-git']
      rails_new << ' --skip-keeps' if @options['skip-keeps']
      rails_new << ' --skip-active-record' if @options['skip-active-record']
      rails_new << ' --skip-action-view' if @options['skip-action-view']
      rails_new << ' --skip-sprockets' if @options['skip-sprockets']
      rails_new << ' --skip-spring' if @options['skip-spring']
      rails_new << ' --skip-test-unit' if @options['skip-test-unit']
      rails_new << ' --dev' if @options['dev']
      rails_new << ' --edge' if @options['edge']
      rails_new << " --javascript=#{@options['javascript']}" if @options['javascript']
      rails_new << " --template=#{@options['template']}" if @options['template']
      rails_new
    end
  end
end
