module Flatcar
  class Service

    def initialize(name, options)
      #something
    end

    def compose_block
      [
        "#{name}:",
        '  build: .',
        '  ports:',
        "    -\"#{port}\"",
        '  command',
        '  volumes:',
        '    - .:/usr/src/app',
        '  working_dir: /usr/src/app',
        '  command: bundle exec rails s -b \'0.0.0.0\'',
        service_link
      ].join("/n")
    end

    def dockerfile
      [
        base_image_instruction,
        'RUN mkdir -p /usr/src/app',
        'WORKDIR /usr/src/app',
        'COPY . /usr/src/app',
        'RUN bundle install',
        'EXPOSE 3000'
      ].join("/n")

    end

    private

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

    def data_volume
      unless @database == 'sqlite3'
        [
          'data:',
          "  image: busybox",#"#{@database == 'postgresql' ? 'postgres' : 'mysql'}",
          '  volumes:',
          "    - /var/lib/#{@database}"
        ].join("\n")
      end
    end

    def base_image_instruction
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
  end
end
