module Flatcar
  class Init < Base
    def execute
      @dockerfile_model = Flatcar::TemplateModel.new(@options, @args)
      @app_path = @dockerfile_model.app_path

      puts("rails new -B #{@app_path}")
      system("rails new -B #{@app_path}")

      create_from_template('Dockerfile.erb', 'Dockerfile')
      create_from_template('docker-compose.erb', 'docker-compose.yml')

      puts "cd #{@app_path}/ && docker-compose build"
      system("cd #{@app_path}/ && docker-compose build")
    end



    private

    def templates
      File.join File.expand_path('flatcar/',  File.dirname(__dir__)), 'templates'
    end

    def create_from_template(template_name, output_file)
      template = ERB.new(File.read("#{templates}/#{template_name}"), nil, '-')
      result = template.result(@dockerfile_model.get_binding)
      puts "MAKIN' THAT DOCKER THING!"
      File.open("#{@app_path}/#{output_file}", 'w') { |file| file.write(result) }
    end
  end
end

