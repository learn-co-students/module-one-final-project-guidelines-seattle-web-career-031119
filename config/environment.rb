require 'bundler'
Bundler.require
require_all 'lib'
require_all 'app'
require_relative "../demofile.rb"
require_relative "../api_key.rb"


ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/food_project.db')
<<<<<<< HEAD
ASCII_FONT = Artii::Base.new
=======
>>>>>>> 17acc31892d891335f52274443e26728f2b1c025
# ActiveRecord::Base.logger.level = Logger::INFO
