module Flatcar
  class PostgresService < Service

    attr_reader :name

    def initialize
      @name = 'postgresql'
    end

    def compose_block
      [
        'db:',
        '  image: postgres',
        '  volumes_from:',
        '    - data',
        '  environment:',
        '    - POSTGRES_PASSWORD=mysecretpassword'
      ].join("\n")
    end

    def data_volume
      [
        'data:',
        '  image: busybox',
        '  volumes:',
        '    - /var/lib/postgresql'
      ].join("\n")
    end

    def database_url
      'postgresql://postgres:mysecretpassword@db/'
    end
  end
end
