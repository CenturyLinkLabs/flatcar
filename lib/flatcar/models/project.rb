module Flatcar
  class Project
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

    def get_binding
      binding()
    end

  end
end
