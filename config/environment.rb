require 'bundler'
# require_relative '../app/models/game.rb'
# require_relative '../app/models/round.rb'
# require_relative '../app/models/player.rb'
Bundler.require

require 'active_record'
require 'rake'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
#require_all '../lib'
