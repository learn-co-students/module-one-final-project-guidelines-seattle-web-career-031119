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
ActiveRecord::Base.logger.level = Logger::INFO
PASTEL = Pastel.new

#-------------MONKEY PATCH METHODS FOR CODE FLOW CLARITY-----------#
class Fixnum
  def to_5_stars
    str = ""
    times do
      str += "\u2605 "
    end
    (5-self).times do
      str += "\u2606 "
    end
    str.chomp
  end
end

class String
  #Defines a character limit so table strings cannot overflow.
  def max_line_length(num)
    return self if self.length < num
    self.scan(/.{1,#{num}}/).join("\n")
  end
end
