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

def ptext(text, color = :red)
  PASTEL.decorate(text, color, :bold)
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

def separator_line
  Paint["~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~", SYSCOLOR, :bold]
end


def congratulate
  systext("\n\nYou're done! Great work!")
end

def happy_shopping
  puts separator_line
  puts "HAPPY SHOPPING! Grab some Oreos® just for fun!"
  puts separator_line
end

def hello_user(user)
  table_one = []
  table_two = []
  shopping_meals = user.meals.where(shopping: true)
  cooked_meals = user.meals.where(active: false)
  latest_meal_output = latest_meal(user)

  table_one << {
    Meals_Saved: user.meals.count,
    Cooked_Meals: cooked_meals.count,
    Recipes_in_Shopping_Cart: shopping_meals.count
  }
  table_two << {Last_Meal_Added: latest_meal_output}
  puts separator_line
  systext("HELLO, #{user.name.upcase}!")
  puts Formatador.display_table(table_one)
  puts separator_line
  puts Formatador.display_table(table_two)
  enter_to_continue
end

def latest_meal(user)
  if user.recipes.count < 1
    "You've added no meals, you silly worm!"
  else
    user.recipes.max.title
  end
end


#-------------USER INPUT PROMPTS------------------#

def get_username
  puts Paint["Please enter your username:", SYSCOLOR, :bold]
  gets.chomp.downcase
end

def get_user_meal_choice(user)
  choice = 0
  loop do
    choice = gets.chomp.to_i-1
    if choice >= 0 && choice < user.get_active_meal_count
      return choice
    else
      systext("Please enter the index of a meal (range 1-#{user.get_active_meal_count})")
    end
  end
end


def get_user_meal_request
  puts "Please enter a meal name (e.g. \"spinach ravioli\" or \"hummus\") to get a recipe:"
  gets.chomp.downcase
end

def enter_to_continue
  puts "Press ENTER to return to the main menu."
  gets
end


def get_user_diet
  diets = ["vegan", "vegetarian", "none"]
  table = []
  response = ""
  puts "Please choose ONE of the following:"
  diets.each do |name|
    table << {
      Diet: name
    }
  end
  Formatador.display_table(table)
  puts separator_line
  loop do
   response = gets.chomp.downcase
   if !diets.include?(response)
     puts "Please enter only one of the options above"
   else
    break
  end
  end
  response
end

def convert_diet_to_syntax
  response = get_user_diet
  if response == "none"
    response = ""
  else
    response = "diet=" + response
  end
  response
end

def get_user_intolerances
  intols = ["dairy", "egg", "gluten", "peanut", "shellfish", "soy", "wheat", "none"]
  response = ""
  table = []
  puts "Please list any food intolerances. Seperate multiple with a comma:"
  intols.each do |name|
    table << {
      Intolerance: name
    }
  end
  Formatador.display_table(table)
  puts separator_line
  loop do
    response = gets.chomp.downcase
    response_array = response.split(/[,\s]+/)
    response = intols.select { |intol| response_array.include?(intol) }
    if response.include?("none") && response.count == 1
      break
    elsif !response.include?("none")
      break
    else
      puts separator_line
      puts "You included 'none' and another option, but that doesn't make sense, you silly little worm."
      puts "Please list any food intolerances. Seperate multiple with a comma:"
    end
  end
  response
end

def convert_intolerance_to_syntax
  response = get_user_intolerances
  if response == ["none"]
    response = ""
  else
    response = 'intolerances=' + response.split(/[,\s]+/).join("%2C+")
  end
  response
end

def combine_diet_intolerances
  diet = convert_diet_to_syntax
  intolerance = convert_intolerance_to_syntax
  if intolerance == ""
    response_syntax = diet
  else
    response_syntax = diet + "&" + intolerance
  end
  response_syntax
end


#TODO: This is a display and a request.  Move to two functions.
def meal_action
  puts Paint["Write an action followed by the index of the meal you wish to change:", SYSCOLOR, :bold]
  table = [
    {Action: "cook", Description: "Change the item to \"Awaiting Cooking\""},
    {Action: "nocook", Description: "Change the item to \"Cooked\""},
    {Action: "remove", Description: "Remove the item from your meals"},
    {Action: "shoplist", Description: "Add the recipe's ingredients to your shopping list"},
    {Action: "unshop", Description: "Remove the recipe's ingredients from your shopping list"},
    {Action: "exit", Description: "Return to main menu (No index needed)"}
  ]
  Formatador.display_table(table)
  gets.chomp
end

def get_user_selection
  choice = 0
  loop do
    choice = gets.chomp.to_i-1
    if choice >= 0 && choice < OPTIONS.count
      break
    else
      systext("You can only select an option between 1 and #{OPTIONS.count}")
    end
  end
  ABBREV_OPTIONS[choice]
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

#------------MAIN MENU------------#
def main_menu
  top_menu_banner
  MENU_MESSAGE.display
  list_selection_options
end


#------------FINDING NEW MEAL ACTIONS-----------#
def finding_action(user)
  find_new_meal_banner
  diet_intolerance = combine_diet_intolerances
  request = get_user_meal_request
  recipe_data = ApiCaller.get_random_recipe_by_search(request, diet_intolerance, user)
  if recipe_data.nil?
    systext("\n\nNo results found for #{request}.  Check your spelling and try again!")
    enter_to_continue
    return
  end
  recipe = Recipe.create_from_data(recipe_data)
  Meal.create(user_id: user.id, recipe_id: recipe.id, active: true, shopping: true)
  MENU_MESSAGE.set_message("Added #{recipe.title} to your meals!\n\n")
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
  meal_choice = get_user_meal_choice(user)
  recipe = user.get_recipe_by_choice(meal_choice)
  recipe.walk_through_steps
  if rate_and_annotate?
    systext("Rating (1-5):")
    user.rate(meal_choice)
    systext("\n\nNotes:")
    user.annotate(meal_choice)
  end
  user.set_cooked(meal_choice)
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
  meal_message = nil
  loop do
    my_meals_banner
    user.print_meals
    systext(meal_message) if !meal_message.nil?
    action = meal_action
    if action == "exit"
      break
    end
    meal_message = user.perform(action)
  end
end
