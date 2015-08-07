module Flatcar
  class MysqlService < Service

    def database_service
      [
        'db:',
        '  image: mysql',
        '  volumes_from:',
        '    - data',
        '  environment:',
        '    - MYSQL_ROOT_PASSWORD=mysecretpassword'
      ].join("\n")
    end

    def data_volume
      [
        'data:',
        '  image: busybox',
        '  volumes:',
        '    - /var/lib/mysql'
      ].join("\n")
    end

    def database_url
      'mysql2://root:mysecretpassword@db/'
    end

  end
end
