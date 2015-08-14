desc 'Initializes a Rails application'
long_desc %{
Packages a Rails application for production deployment
}
command :build do |c|
  c.action do |global_options,options,args|
    @project = Flatcar::Project.package(options, args)
  end
end