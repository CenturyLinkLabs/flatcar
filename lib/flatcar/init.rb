module Flatcar
  class Init < Base
    def execute
      @project = Flatcar::Project.new(options, args)
      @project.write_dockerfile
      @project.write_compose_yaml
      @project.build
    end
  end
end

