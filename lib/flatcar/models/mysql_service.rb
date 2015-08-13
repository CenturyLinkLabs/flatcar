module Flatcar
  class MysqlService < Service

    attr_reader :name

    def initialize
      @name = 'mysql'
    end

    def to_h
      {
        'db' => {
          'image' => 'mysql',
          'volumes_from' => [ 'data' ],
          'environment' => [ 'MYSQL_ROOT_PASSWORD=mysecretpassword' ],
        },
        'data' => {
          'image' => 'busybox',
          'volumes' => [ '/var/lib/mysql' ]
        }
      }
    end

    def database_url
      'mysql2://root:mysecretpassword@db/'
    end
  end
end
