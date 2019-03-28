require_relative 'config/environment'
require 'sinatra/activerecord/rake'

desc 'starts a console'
task :console do
  Pry.start
end

desc 'starts a console with queries'
task :query do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  locations = match_input_to_location("Springfield")
  suggestions_menu = location_suggestions(locations)
  pretty_menu = pretty_location_menu(suggestions_menu, locations)
  cuisine_selection = 1 + Random.rand(9)
  binding.pry
end
