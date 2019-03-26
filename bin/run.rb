require_relative '../config/environment'
require "pry"


# demo_data = dummy
# recipe_data = ApiCaller.get_recipe_by_id(578572)
# recipe = Recipe.create_from_data(recipe_data.body)

welcome
user = User.find_or_create_by(name: get_username)
list_selection_options
user_selection = get_user_selection

loop do
  case user_selection
  when "find"
    request = get_user_meal_request
end
