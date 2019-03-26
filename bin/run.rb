require_relative '../config/environment'
require "pry"


# demo_data = dummy
recipe_data = ApiCaller.get_recipe_by_id(578572)


binding.pry
puts "HELLO WORLD"
