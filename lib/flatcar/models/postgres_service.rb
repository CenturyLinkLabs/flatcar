module Flatcar
  class PostgresService < Service

    def database_service
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
