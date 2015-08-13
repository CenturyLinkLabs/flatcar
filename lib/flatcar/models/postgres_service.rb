require('yaml')

module Flatcar
  class PostgresService < Service

    attr_reader :name

    def initialize
      @name = 'postgresql'
    end

    def to_h
      {
        'db' => {
          'image' => 'postgres',
          'volumes_from' => [ 'data' ],
          'environment' => [ 'POSTGRES_PASSWORD=mysecretpassword' ]
        },
        'data' => {
          'image' => 'busybox',
          'volumes' => [ '/var/lib/postgresql' ]
        }
      }
    end

    def database_url
      'postgresql://postgres:mysecretpassword@db/'
    end

  end
end
