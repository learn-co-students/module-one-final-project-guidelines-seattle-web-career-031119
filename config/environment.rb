require 'bundler'
Bundler.require
require_all 'lib'
require_all 'app'
require_relative "../demofile.rb"
require_relative "../api_key.rb"


ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/food_project.db')
ASCII_FONT = Artii::Base.new
SYSCOLOR = :magenta
SUB_BANNER_COLOR = :green
# ActiveRecord::Base.logger.level = Logger::INFO
