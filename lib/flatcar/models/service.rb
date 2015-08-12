module Flatcar
  class Service

    def self.instance(service_type, options={})
      case service_type
      when 'postgresql'
        PostgresService.new
      when 'mysql'
        MysqlService.new
      when 'sqlite3'
        return
      when 'webapp'
        WebappService.new(options[:base_image], options[:database])
      else
        raise("Unrecognized service type #{service_type}")
      end
    end
  end
end
