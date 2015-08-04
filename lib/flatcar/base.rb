module Flatcar
  class Base
    attr_accessor :args, :options

    def initialize(args, options={})
      @args = args
      @options = options
    end

    def args_string
      @args.join(' ')
    end

    def options_string
      puts options.inspect
      @options.each_with_object('') do |pair, memo|
        if pair[1]
          if pair[0].length == 1
            memo << " -#{pair[0]}"
          else
            memo << " --#{pair[0]}=#{pair[1]}"
          end
        end
      end
    end
  end
end
