module Flatcar
  class Init < Base
    def execute
      @project = Flatcar::Project.new(options, args)
      @project.write_dockerfile
      @project.write_compose_yaml
      @project.build
    end

    private

    def templates
      File.join File.expand_path('flatcar/',  File.dirname(__dir__)), 'templates'
    end

    def create_from_template(template_name, output_file)
      template = ERB.new(File.read("#{templates}/#{template_name}"), nil, '-')
      result = template.result(@project.get_binding)
      puts "MAKIN' THAT DOCKER THING!"
      File.open("#{@app_path}/#{output_file}", 'w') { |file| file.write(result) }
    end
  end
end

