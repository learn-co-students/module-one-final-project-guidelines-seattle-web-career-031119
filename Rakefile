require_relative 'config/environment'
require 'sinatra/activerecord/rake'

desc 'starts a console'
task :console do
  Pry.start
end

desc 'starts a console with queries'
task :query do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  locations = match_input_to_location("Fremont")
  suggestions_menu = location_suggestions(locations)
  binding.pry
end
