require 'bundler'
require 'active_record'
require 'rake'
require 'require_all'

Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
ActiveRecord::Base.logger = nil

require_all 'app'
require_all 'lib'

SINATRA_ACTIVESUPPORT_WARNING=false
