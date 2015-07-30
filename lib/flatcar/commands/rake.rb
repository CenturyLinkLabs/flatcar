desc 'Runs rake tasks on the Rails application in a Docker container'
command :rake do |c|
  c.instance_eval do
    desc 'Do a dry run without executing actions.'
    switch [:n, :'dry-run']

    desc 'Display the tasks (matching optional PATTERN) with descriptions, then exit.'
    switch [:T, :'tasks']

    action do |global_options,options,args|
      Flatcar::Rake.new(args, options).execute
    end
  end
end
