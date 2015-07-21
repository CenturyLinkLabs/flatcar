module Flatcar
  name = ARGV[1] || 'we_have_app'
  puts "bundle exec rails new #{name}"
end
