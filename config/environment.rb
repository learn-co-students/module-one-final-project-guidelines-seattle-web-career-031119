require 'bundler'
Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/food_project.db')
require_all 'lib'
require_all 'app'
require_relative "../demofile.rb"
require_relative "../api_key.rb"
