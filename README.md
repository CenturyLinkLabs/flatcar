# Flatcar

Developing Rails applications with Docker is easy with Flatcar. Using native Docker commands, Flatcar will build
your application and link it to whatever database you choose to use.

##Installation and Dependencies
Flatcar depends on [Docker](https://www.docker.com). You must have Docker and Docker Compose installed on your machine in order for Flatcar to work. If you are on Linux, [install Docker](http://docs.docker.com/linux/step_one/) with official packages. On a [Mac](http://docs.docker.com/mac/started/) or [Windows](http://docs.docker.com/windows/started/), you will need to run a lightweight VM in order to use Docker. You can do this via [Docker Toolbox](https://www.docker.com/toolbox) or by running a VM of your choice.

Then, `gem install flatcar` and you're ready to get rolling.

##Usage
####Creating a new Rails project
From the desired parent directory, run `flatcar init $new_project_name`. This will initialize a new Rails application in a directory of the same name. 

####Using an existing Rails project
Run `flatcar init $path_to_project` to begin a new project. You can initialize a flatcar project from the current directory by simply running `flatcar init`.

`flatcar init ($new_project_name|$path_to_project)` will perform the following operations:

1. If no project path is specified, it runs `rails new -B $app_path`. 
2. Flatcar generates a Dockerfile for the Rails service
3. A docker-compose.yml file is generated for the entire project.

Flatcar applications are run via `docker-compose` in the project's directory. If you're using a VM, make sure to create appropriate port forwarding rules in order to view the application in your browser. Flatcar will bind 3000:3000 from host:container via Docker's `-p` flag at runtime.

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
First, `git clone https://github.com/CenturyLinkLabs/flatcar.git`.
Flarcar uses GLI, which is a very useful tool for writing command line tools. More information on GLI can be found on [the project page](http://naildrivin5.com/gli/) as well as the [GitHub repo](https://github.com/davetron5000/gli).
To run flatcar in development mode, we recommend passing in GLI_DEBUG=true to your run command.  


