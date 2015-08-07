module Flatcar
  class Project
    attr_accessor :name, :database

    def self.init(options, args)
      project = new(options, args)
      project.write_dockerfile
      project.write_compose_yaml
      project.build
    end

    def initialize(options, args)
      @args = args
      @name = project_name
      @database = Service.instance(options[:d])
      @webapp = Service.instance('webapp', base_image: options[:b], database: @database)
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
      File.open("#{app_path}/docker-compose.yml", 'w') { |file| file.write(compose_yaml) }
    end


    # def create_from_template(template_name, output_file)
    #   template = ERB.new(File.read("#{templates}/#{template_name}"), nil, '-')
    #   result = template.result(@project.get_binding)
    #   File.open("#{@app_path}/#{output_file}", 'w') { |file| file.write(result) }
    # end

    def get_binding
      binding()
    end

    def build
      puts "cd #{app_path}/ && docker-compose build"
      system("cd #{app_path}/ && docker-compose build")
    end

    private

    def fs_init
      rails_new = "rails new -B #{app_path}"
      rails_new += " -d #{database}" unless database == 'sqlite3'

      puts(rails_new)
      system(rails_new)
    end
  end
end
