module Flatcar
  class Base
    attr_accessor :args, :options

    def initialize(args, options={})
      @args = args
      @options = options
    end
  end
end
