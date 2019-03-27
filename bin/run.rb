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
    Meal.create(user_id: user.id, recipe_id: recipe.id, active: true)
    print_selection_title(recipe)
  when "cook"
    user.print_active_meals
    meal_choice = get_user_meal_choice
    recipe = user.get_recipe_by_choice(meal_choice)
    recipe.walk_through_steps
    congratulate
    user.set_cooked(meal_choice)
  when "list"
    user.get_ingredient_list

  when "meals"
    loop do
      user.print_meals
      action = meal_action
      if action == "exit"
        break
      end
      user.perform(action)
    end
  when "exit"
    break
  end
end
