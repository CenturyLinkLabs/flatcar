module Flatcar
  class TemplateModel
    attr_accessor :name, :base_image

    def initialize(options, args)
      @options = options.dup
      @args = args.dup
      @base_image = @options[:b]
      @name = project_name
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

    def dockerfile_header
      case @base_image
      when 'alpine'
        [
          'FROM centurylink/alpine-rails'
        ].join("\n")
      when 'ubuntu'
        [
          'FROM centurylink/ubuntu-rails'
        ].join("\n")
      else
        [
          'FROM rails:latest',
          'RUN apt-get update && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*',
          'RUN apt-get update && apt-get install -y mysql-client postgresql-client sqlite3 --no-install-recommends && rm -rf /var/lib/apt/lists/*'
        ].join("\n")
      end
    end

    def get_binding
      binding()
    end

  end
end
