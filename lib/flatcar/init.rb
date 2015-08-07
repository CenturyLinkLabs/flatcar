module Flatcar
  class Init < Base
    def execute
      @template_model = Flatcar::TemplateModel.new(options, args)
      @app_path = @template_model.app_path

      rails_new = "rails new -B #{@app_path}"
      rails_new += " -d #{@template_model.database}" unless @template_model.database == 'sqlite3'

      puts(rails_new)
      # system("mkdir #{@app_path}")
      system(rails_new)

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
      result = template.result(@template_model.get_binding)
      puts "MAKIN' THAT DOCKER THING!"
      File.open("#{@app_path}/#{output_file}", 'w') { |file| file.write(result) }
    end
  end
end

