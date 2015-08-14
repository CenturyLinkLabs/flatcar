# Flatcar

Developing Rails applications with Docker is easy with Flatcar. Using native Docker commands, Flatcar will build
your application and link it to whatever database you choose to use.

##Installation
`gem install flatcar` and you're ready to go.


##Usage
*creating a new Rails project*

*with an existing Rails project*
`flatcar init $path_to_project` to begin a new project. You can initialize a flatcar project from the current directory by simply running `flatcar init`.

`flatcar init $` does three things.
1. If no project path is specified, it runs `rails new -B $app_path`. 
2. Flatcar generates a Dockerfile for the Rails service
3. A docker-compose.yml file is generated for the entire project.

To run the application, cd into the project directory and run `docker-compose up`.

####init
Flatcar uses the following syntax: `flatcar [global options] init [command options] [APP_NAME]`

The `init` command initializes a Rails application with an optional base image and database specified. If executed within an existing Rails project directory without the APP_NAME argument, the Flatcar generated files will be placed in the current directory. If the command is executed with the optional APP_NAME argument, a new Rails project will be generated along with the Flatcar files in a subdirectory of the current directory.

#####Selecting a base image
You can specify which OS to use for your Rails service by passing in the -b flag. Valid options are alpine, ubuntu, or rails (debian-based). If no option is given, the default Rails image will be used.

#####Choosing a database
You can also specify which database to use with your Rails application. Valid options are mysql, postgresql, or sqlite3. If mysql or postgresql is chosen, a new database service will be defined in the generated docker-compose.yml file. If no option is given, sqlite3 will be used. 

#####Command Options

Command                            | Description
-----------------------------------|----------------------------
- `-G`, `--[no-]skip-git`          |Skip .gitignore file
- `-J`, `--[no-]skip-javascript`   |Skip JavaScript files
- `-O, --[no-]skip-active-record`  |Skip Active Record files
- `-S, --[no-]skip-sprockets`      |Skip Sprockets files
- `-T, --[no-]skip-test-unit`      |Skip Test::Unit files
- `-V, --[no-]skip-action-view`    |Skip Action View files
- `-b, --base=BASE_IMAGE`          |Sets the base image to use in the Dockerfile (default: rails)
- `-d, --database=DATABASE`        |Sets the database to use. (default: sqlite3)
- `--[no-]dev`                     |Setup the application with Gemfile pointing to your Rails checkout
- `--[no-]edge`                    |Setup the application with Gemfile pointing to Rails repository
- `-j, --javascript=JAVASCRIPT`    |Preconfigure for selected JavaScript library. (default: jquery)
- `-m, --template=TEMPLATE`        |Path to some application template (can be a filesystem path or URL) (default: none)
- `--[no-]skip-keeps`              |Skip source control .keep files
- `--[no-]skip-spring`             |Don't install Spring application preloader

##Testing
Flatcar uses rspec. To run the test suite, run `bundle exec rspec spec`.

##Contributing
Flatcar uses an Apache License and your contributions are welcome.
