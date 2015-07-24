module Flatcar
  class Runner

    attr_reader :args, :name

    def initialize(args)
      @args = args
    end


    def execute
      command = args.shift

      case command
      when 'new'
        @name = args.shift || 'we_have_app'
        options = args
        system("rails #{command} #{name} -B #{options.join(' ')}")
        create_from_template('Dockerfile.erb', 'Dockerfile')
        create_from_template('Dockerfile-pro.erb', 'Dockerfile-pro')
        create_from_template('docker-compose.yml.erb', 'docker-compose.yml')
        puts "cd #{name}/ && docker-compose build"
        system("cd #{name}/ && docker-compose build")
      when 'run'
        system("docker-compose up")
      else
        puts "Error: Command '#{command}' not recognized"
      end
    end

    private

    def templates
      File.join File.expand_path('..',  File.dirname(__dir__)), 'templates'
    end

    def create_from_template(template_name, output_file)
      template = ERB.new(File.read("#{templates}/#{template_name}"), nil, '-')
      result = template.result(binding)
      puts "MAKIN' THAT DOCKER THING!"
      File.open("#{name}/#{output_file}", 'w') { |file| file.write(result) }
    end

  end
end
