desc 'Creates a new Ruby on Rails project along with a Dockerfile and docker-compose.yml'
arg 'APP_PATH'
command :new do |c|
  c.instance_eval do
    desc 'Skip JavaScript files'
    switch [:J]

    desc 'Preconfigure for selected JavaScript library'
    default_value 'jquery'
    flag [:j]

    action do |global_options,options,args|
      Flatcar::New.new(args).execute
    end
  end
end
