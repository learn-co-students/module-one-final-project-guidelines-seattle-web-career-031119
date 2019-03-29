require_relative 'config/environment'
require 'sinatra/activerecord/rake'

desc 'runs the game'
task :run do
  ruby "bin/run.rb"
end

desc 'starts a console'
task :console do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  Pry.start
end
