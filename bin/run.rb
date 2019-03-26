require_relative '../config/environment'
require "pry"


# demo_data = dummy
recipe_data = ApiCaller.get_recipe_by_id(578572)
recipe = Recipe.create_from_data(recipe_data.body)


binding.pry
puts "HELLO WORLD"
