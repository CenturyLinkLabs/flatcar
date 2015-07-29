desc 'Runs the Rails application in a Docker container'
command :run do |c|
  c.instance_eval do
    action do |global_options,options,args|
      Flatcar::Run.new(args).execute
    end
  end
end
