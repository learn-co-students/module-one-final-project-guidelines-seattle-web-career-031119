require_relative '../config/environment'
require "pry"


# demo_data = dummy
# recipe_data = ApiCaller.get_recipe_by_id(578572)
# recipe = Recipe.create_from_data(recipe_data.body)

welcome
user = User.find_or_create_by(name: get_username)

loop do
  list_selection_options
  user_selection = get_user_selection

  case user_selection
  when "find"
    request = get_user_meal_request
    recipe_data = ApiCaller.get_random_recipe_by_search(request)
    recipe = Recipe.create_from_data(recipe_data.body)
    Meal.create(user_id: user.id, recipe_id: recipe.id)
  when "cook"
    user.print_recipe_options
    meal_choice = get_user_meal_choice
    recipe = user.get_recipe_by_choice(meal_choice)
    recipe.walk_through_steps
    congratulate
  when "exit"
    break
  end
  binding.pry
end
