module Flatcar
  module Templates
    module CommandUtils
      def templates
        File.join File.expand_path('../flatcar/',  File.dirname(__dir__)), 'templates'
      end

      def create_from_template(template_name, output_file)
        template = ERB.new(File.read("#{templates}/#{template_name}"), nil, '-')
        result = template.result(binding)
        puts "MAKIN' THAT DOCKER THING!"
        File.open("#{@name}/#{output_file}", 'w') { |file| file.write(result) }
      end
    end
  end
end
