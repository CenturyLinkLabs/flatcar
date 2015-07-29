module Flatcar
  class Rake < Base
    def execute
      system("docker-compose run webapp rake #{args.join(' ')}")
    end
  end
end
