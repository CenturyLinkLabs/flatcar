module Flatcar
  class Run < Base
    def execute
      system("docker-compose up")
    end
  end
end
