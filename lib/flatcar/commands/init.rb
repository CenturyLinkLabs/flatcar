desc 'Initializes a Rails application'
long_desc %{
Initializes a Rails application with an optional base image and database specified.  If
executed within an existing Rails project directory without the APP_NAME argument, the
Flatcar generated files will be placed in the current directory.
If the command is executed with the optional APP_NAME argument, a new Rails project will be
generated along with the Flatcar files in a subdirectory of the current directory.
\n
Valid values for BASE_IMAGE are: alpine, ubuntu, or rails (debian-based).
\n
Valid values for DATABASE are: mysql, postgresql, or sqlite3.  If mysql or postgresql is chosen, a new database service
will be defined in the generated docker-compose.yml file.
}
arg 'APP_NAME', :optional
command :init do |c|
  c.flag [:b, :base],
         default_value: 'rails',
         desc: 'Sets the base image to use in the Dockerfile',
         arg_name: 'BASE_IMAGE'

  c.flag [:d, :database],
         default_value: 'sqlite3',
         desc: 'Sets the database to use.',
         arg_name: 'DATABASE'

  c.action do |global_options,options,args|

    unless %w(mysql postgresql sqlite3).include? options[:d]
      help_now! 'Invalid value for --database option. Must be one of: mysql, postgresql, sqlite3'
    end

    unless %w(rails alpine ubuntu).include? options[:b]
      help_now! 'Invalid value for --base option. Must be one of: rails, alpine, ubuntu'
    end

    @project = Flatcar::Project.init(options, args)
  end
end
