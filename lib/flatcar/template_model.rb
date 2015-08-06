module Flatcar
  class TemplateModel
    attr_accessor :name, :base_image, :database

    def initialize(options, args)
      @options = options.dup
      @args = args.dup
      @base_image = @options[:b]
      @database = @options[:d]
      @name = project_name

      unless %w(mysql postgresql sqlite3).include? @options[:d]
        help_now! 'Invalid value for --database option. Must be one of: mysql, postgresql, sqlite3'
      end

      unless %w(rails alpine ubuntu).include? @base_image
        help_now! 'Invalid value for --base option. Must be one of: rails, alpine, ubuntu'
      end
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

    def service_link
      [
        'environment:',
        "    - DATABASE_URL=#{database_url}",
        '  links:',
        '    - db:db'
      ].join("\n") if @database != 'sqlite3'
    end

    def database_url
      case @database
      when 'postgresql'
        'postgresql://postgres:mysecretpassword@db/'
      when 'mysql'
        'mysql2://root:mysecretpassword@db/'
      end
    end

    def database_service
      case @database
      when 'postgresql'
        [
          'db:',
          '  image: postgres',
          '  volumes_from:',
          '    - data',
          '  environment:',
          '    - POSTGRES_PASSWORD=mysecretpassword'
        ].join("\n")
      when 'mysql'
        [
          'db:',
          '  image: mysql',
          '  volumes_from:',
          '    - data',
          '  environment:',
          '    - MYSQL_ROOT_PASSWORD=mysecretpassword'
        ].join("\n")
      end
    end

    def data_volume_service
      unless @database == 'sqlite3'
        [
          'data:',
          "  image: busybox",#"#{@database == 'postgresql' ? 'postgres' : 'mysql'}",
          '  volumes:',
          "    - /var/lib/#{@database}"
        ].join("\n")
      end
    end

    def get_binding
      binding()
    end

  end
end
