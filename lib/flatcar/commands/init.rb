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
         must_match: %w(rails alpine ubuntu),
         arg_name: 'BASE_IMAGE'

  c.flag [:d, :database],
         default_value: 'sqlite3',
         desc: 'Sets the database to use.',
         must_match: %w(mysql postgresql sqlite3),
         arg_name: 'DATABASE'

  c.flag [:m, :template],
         desc: 'Path to some application template (can be a filesystem path or URL)',
         arg_name: 'TEMPLATE'

  c.switch [:G, :'skip-git'],
           desc: 'Skip .gitignore file'

  c.switch [:'skip-keeps'],
           desc: 'Skip source control .keep files'

  c.switch [:O, :'skip-active-record'],
         desc: 'Skip Active Record files'

  c.switch [:V, :'skip-action-view'],
           desc: 'Skip Action View files'

  c.switch [:S, :'skip-sprockets'],
           desc: 'Skip Sprockets files'

  c.switch [:'skip-spring'],
           desc: "Don't install Spring application preloader"

  c.flag [:j, :javascript],
         default_value: 'jquery',
         desc: 'Preconfigure for selected JavaScript library.',
         arg_name: 'JAVASCRIPT'

  c.switch [:J, :'skip-javascript'],
           desc: 'Skip JavaScript files'

  c.switch [:T, :'skip-test-unit'],
           desc: 'Skip Test::Unit files'

  c.switch [:dev],
           desc: 'Setup the application with Gemfile pointing to your Rails checkout'

  c.switch [:edge],
           desc: 'Setup the application with Gemfile pointing to Rails repository'

  c.action do |global_options,options,args|
    @project = Flatcar::Project.init(options, args)
  end
end
