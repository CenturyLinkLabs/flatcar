module Flatcar
  class New < Base
    def execute
      @name = args.shift || 'we_have_app'
      # options = args
      puts("rails new #{@name} -B #{args.join(' ')}")
      system("rails new #{@name} -B #{args.join(' ')}")
      create_from_template('Dockerfile.erb', 'Dockerfile')
      create_from_template('Dockerfile-pro.erb', 'Dockerfile-pro')
      create_from_template('docker-compose.yml.erb', 'docker-compose.yml')
      puts "cd #{@name}/ && docker-compose build"
      system("cd #{@name}/ && docker-compose build")
    end

    private

    def templates
      File.join File.expand_path('flatcar/',  File.dirname(__dir__)), 'templates'
    end

    def create_from_template(template_name, output_file)
      template = ERB.new(File.read("#{templates}/#{template_name}"), nil, '-')
      result = template.result(binding)
      puts "MAKIN' THAT DOCKER THING!"
      File.open("#{@name}/#{output_file}", 'w') { |file| file.write(result) }
    end
  end
end

