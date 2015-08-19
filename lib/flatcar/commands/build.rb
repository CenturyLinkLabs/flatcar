desc 'Initializes a Rails application'
long_desc %{
Packages a Rails application for production deployment.
}
command :build do |c|
  c.flag [:b, :base],
         default_value: 'rails',
         desc: 'Sets the base image to use in the Dockerfile',
         must_match: %w(rails alpine ubuntu),
         arg_name: 'BASE_IMAGE'

  c.flag [:d, :database],
         default_value: 'sqlite3',
         desc: 'Sets the database to use.',
         must_match: %w(mysql postgresql sqlite3),
         arg_name: 'DATABASE'

  c.action do |global_options,options,args|
    @project = Flatcar::Project.build(options, args)
  end
end
