OPTIONS=["Find a Recipe","Cook a Recipe", "My Shopping List", "My Saved Meals", "Exit"]

ABBREV_OPTIONS = ["find", "cook", "list", "meals", "exit"]

#--------------SYSTEM MESSAGES-------------#
def sysbanner(title, color = SUB_BANNER_COLOR)
  system "clear"
  puts Paint[ASCII_FONT.asciify(" #{title} "), color, :bold, :inverse]
end

def systext(text, color = SYSCOLOR)
  puts Paint[text, SYSCOLOR, :bold]
end

def welcome
  system "clear"
  sysbanner("Welcome To Mealworm!", :cyan)
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
  puts "\n\nYou're done! Great work!"
end

def happy_shopping
  puts separator_line
  puts "HAPPY SHOPPING! Grab some Oreos® just for fun!"
  puts separator_line
end

def hello_user(user)
  puts "Hello #{user.name}!"
  puts separator_line
  enter_to_continue
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
  puts "Please enter a meal name (e.g. \"spinach ravioli\" or \"sushi\") to get a recipe:"
  gets.chomp.downcase
end

def enter_to_continue
  puts "Press ENTER to return to the main menu."
  gets
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

def rate_and_annotate?
  systext("Would you like to rate and/or make notes on this recipe? (Y/N)")
  response = gets.chomp.downcase
  yn(response)
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

#----------------HELPER FUNCTIONS------------#
def yn(str)
  if str == "y" || str ==  "yes"
    return true
  else
    return false
  end
end



#------------FINDING NEW MEAL ACTIONS-----------#
def finding_action(user)
  find_new_meal_banner
  request = get_user_meal_request
  recipe_data = ApiCaller.get_random_recipe_by_search(request)
  if recipe_data.nil?
    systext("\n\nNo results found for #{request}.  Check your spelling and try again!")
    enter_to_continue
    return
  end
  recipe = Recipe.create_from_data(recipe_data.body)
  Meal.create(user_id: user.id, recipe_id: recipe.id, active: true, shopping: true)
  print_selection_title(recipe)
end

#------------COOKING ACTIONS-----------#
def cooking_actions(user)
  cooking_banner
  if !user.has_active_meals?
    systext("You currently have no meals awaiting cooking. Add some from your past recipes, or add new ones via the find menu!")
    enter_to_continue
    return
  end
  user.print_active_meals
  meal_choice = get_user_meal_choice
  recipe = user.get_recipe_by_choice(meal_choice)
  recipe.walk_through_steps
  user.set_cooked(meal_choice)
  if rate_and_annotate?
    systext("Rating (1-5):")
    user.rate(meal_choice)
    systext("\n\nNotes:")
    user.annotate(meal_choice)
  end
  enter_to_continue
end
#------------SHOPPING LIST ACTIONS-----------#
def shoplist_action(user)
  sysbanner("Shopping List")
  user.get_ingredient_list
  happy_shopping
  enter_to_continue
end

#------------MEALS ACTIONS-----------#
def meals_actions(user)
  loop do
    my_meals_banner
    user.print_meals
    action = meal_action
    if action == "exit"
      break
    end
    user.perform(action)
  end
end
