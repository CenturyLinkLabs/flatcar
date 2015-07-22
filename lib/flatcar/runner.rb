module Flatcar
  class Runner

    attr_reader :args

    def initialize(args)
      @args = argsgty
    end

    def execute
      command = args.shift

      case command
      when 'new'
        name = args.shift || 'we_have_app'
        options = args
        exec "rails #{command} #{name} -B #{options.join(' ')}"
      when 'run'
        exec "docker run -it -v #{Dir.pwd}:/home/app -w /home/app -p 3000:3000 centurylink/ruby-base bundle && bundle exec rails s"
      else
        puts "Error: Command '#{command}' not recognized"
      end
    end

  end
end
