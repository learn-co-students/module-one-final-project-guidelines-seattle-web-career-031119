OPTIONS=["Find a Recipe","Cook a Recipe", "My Shopping List", "My Saved Meals", "Exit"]

ABBREV_OPTIONS = ["find", "cook", "list", "meals", "exit"]

#--------------SYSTEM MESSAGES-------------#
def welcome
  system "clear"
  puts Paint[ASCII_FONT.asciify(" Welcome To Mealworm! "), :cyan, :bold, :inverse]
end

def sysbanner(title)
  system "clear"
  puts Paint[ASCII_FONT.asciify(" #{title} "), SUB_BANNER_COLOR, :bold, :inverse]
end

def top_menu_banner
  sysbanner("Main Menu")
end

def my_meals_banner
  sysbanner("My Saved Meals")
end

def cooking_banner
  sysbanner("Cooking")
end

def find_new_meal_banner
  sysbanner("Find A New Meal")
end

def exit_banner
  sysbanner("Enjoy your meal!")
end

#TODO: This doesn't belong here.
def print_selection_title(recipe)
  puts "Added #{recipe.title} to your meals!\n\n"
end

def separator_line
  Paint["~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~", SYSCOLOR, :bold]
end

def congratulate
  puts "Great work!  Hope it tastes as good as you look. ;)"
end

def happy_shopping
  puts separator_line
  puts "HAPPY SHOPPING! Grab some Oreos® just for fun!"
  puts separator_line
end

#-------------USER INPUT PROMPTS------------------#

def get_username
  puts Paint["Please enter your username:", SYSCOLOR, :bold]
  gets.chomp.downcase
end

def get_user_meal_choice
  gets.chomp.to_i-1
end

def get_user_meal_request
  puts "Please enter a meal name:"
  gets.chomp.downcase
end

#TODO: This is a display and a request.  Move to two functions.
def meal_action
  puts Paint["Write an action followed by the index of the meal you wish to change:", SYSCOLOR, :bold]
  table = [
    {Action: "cook", Description: "Change the item to \"Awaiting Cooking\""},
    {Action: "remove", Description: "Remove the item from your meals."},
    {Action: "shoplist", Description: "Add the recipe's ingredients to your shopping list"},
    {Action: "unshop", Description: "Remove the recipe's ingredients from your shopping list"},
    {Action: "exit", Description: "Return to main menu (No index needed)"}
  ]
  Formatador.display_table(table)
  gets.chomp
end

def get_user_selection
  choice = ABBREV_OPTIONS[gets.chomp.to_i-1]
end

#-------------MENUS-------------------#

def list_selection_options
  puts Paint["Please enter a number 1-#{OPTIONS.count} to select a menu item:", SYSCOLOR, :bold]
  table = []
  OPTIONS.each_with_index {|option, index|
    table << {Index: index+1, Option: option}
  }
  Formatador.display_table(table)
  puts separator_line
end




#------------COOKING ACTIONS-----------#
def cooking_actions(user)
  cooking_banner
  user.print_active_meals
  meal_choice = get_user_meal_choice
  recipe = user.get_recipe_by_choice(meal_choice)
  recipe.walk_through_steps
  congratulate
  user.set_cooked(meal_choice)
end

#------------FINDING NEW MEAL ACTIONS-----------#
def finding_action(user)
  find_new_meal_banner
  request = get_user_meal_request
  recipe_data = ApiCaller.get_random_recipe_by_search(request)
  recipe = Recipe.create_from_data(recipe_data.body)
  Meal.create(user_id: user.id, recipe_id: recipe.id, active: true, shopping: true)
  print_selection_title(recipe)
end

#------------MEALS ACTIONS-----------#
def meals_actions(user)
  my_meals_banner
  loop do
    user.print_meals
    action = meal_action
    if action == "exit"
      break
    end
    user.perform(action)
  end
end
