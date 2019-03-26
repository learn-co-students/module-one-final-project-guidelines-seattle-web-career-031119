OPTIONS=["Find a Recipe","Cook a Recipe", "My Shopping List", "My Saved Meals"]

ABBREV_OPTIONS = ["find", "cook", "list", "meals"]

def welcome
  "Welcome to MealWorm!"
end

def get_username
  puts "Please enter your username:"
  gets.chomp.downcase
end

def list_selection_options
  puts "Please enter a number 1-#{OPTIONS.count}:"
  OPTIONS.each_with_index {|option, index|
    puts "#{index+1}. #{option}"
  }
  puts "==============="
end

def get_user_selection
  choice = ABBREV_OPTIONS[gets.chomp.to_i-1]
end

def get_user_meal_request
  puts "Please enter a meal name"
  gets.chomp.downcase
end
