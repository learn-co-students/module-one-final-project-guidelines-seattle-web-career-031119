OPTIONS=["Find a Recipe","Cook a Recipe", "My Shopping List", "My Saved Meals", "Exit"]

ABBREV_OPTIONS = ["find", "cook", "list", "meals", "exit"]

def welcome
  system "clear"
  puts Paint[" Welcome to MealWorm! ", :cyan, :bold, :inverse]
end

def sepparator_line
  Paint["~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~", :black, :bold]
end

def get_username
  puts Paint["Please enter your username:", :black, :bold]
  gets.chomp.downcase
end

def list_selection_options
  puts Paint["Please enter a number 1-#{OPTIONS.count} to select a menu item:", :black, :bold]
  table = []
  OPTIONS.each_with_index {|option, index|
    table << {Index: index+1, Option: option}
  }
  Formatador.display_table(table)
  puts sepparator_line
end

def get_user_selection
  choice = ABBREV_OPTIONS[gets.chomp.to_i-1]
end

def get_user_meal_choice
  gets.chomp.to_i-1
end

def get_user_meal_request
  puts "Please enter a meal name:"
  gets.chomp.downcase
end

def print_selection_title(recipe)
  puts "Added #{recipe.title} to your meals!\n\n"
end

def meal_action
  puts Paint["Write an action followed by the index of the meal you wish to change:", :black, :bold]
  table = [
    {Action: "cook", Description: "Change the item to \"Awaiting Cooking\""},
    {Action: "remove", Description: "Remove the item from your meals."},
    {Action: "shoplist", Description: "Add the recipe's ingredients to your shopping list"},
    {Action: "exit", Description: "Return to main menu (No index needed)"}
  ]
  Formatador.display_table(table)
  gets.chomp
end

def congratulate
  puts "Great work!  Hope it tastes as good as you look. ;)"
end
