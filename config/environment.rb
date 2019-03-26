require 'bundler'
Bundler.require
require_all 'lib'
require_all 'app'
require_relative "../demofile.rb"
require_relative "../api_key.rb"


ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/food_project.db')
ActiveRecord::Base.logger.level = Logger::INFO
