require('yaml')

module Flatcar
  class WebappService < Service

    def initialize(base_image, database)
      @base_image = base_image
      @database = database
    end

    def dockerfile
      [
        base_image_instruction,
        'RUN mkdir -p /usr/src/app',
        'WORKDIR /usr/src/app',
        'COPY . /usr/src/app',
        'RUN bundle install',
        'EXPOSE 3000'
      ].join("\n")
    end

    def to_h
      service_def = {
        'webapp' => {
          'build' => '.',
          'ports' => ['3000:3000'],
          'volumes' => ['.:/usr/src/app'],
          'working_dir' => '/usr/src/app',
          'command' => "bundle exec rails s -b '0.0.0.0'"
        }
      }
      service_def['webapp'].merge!(service_link) if @database
      service_def
    end

    private

    def service_link
      {
        'environment' => ["DATABASE_URL=#{@database.database_url}"],
        'links' => ['db:db']
      }
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
