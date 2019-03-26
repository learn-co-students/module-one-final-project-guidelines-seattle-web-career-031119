require 'bundler'
require 'pry'
require 'json'
#require 'unirest'
require 'nokogiri'
require 'rake'
require 'sqlite3'

require_relative '../app/test.rb'

Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'
