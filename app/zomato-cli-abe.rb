## too many methods in here

def flexible_menu(prompt, cases)
  #this is when you want the user to choose from options
  active = 1
  while active == 1 do
    puts prompt
    case cases[:format]
    when "string"
      user_response = STDIN.gets.chomp.downcase
    when "int"
      user_response = STDIN.gets.chomp.to_i
    else
      user_response = STDIN.gets.chomp.downcase
    end

    case
    when cases.keys.include?(user_response)
      active = 0
      cases[user_response]
    when user_response == 'quit' || 'exit'
      active = 0
      exit
    else
      puts "Sorry, I didn\'t understand."
    end
  end
end

def get_input(prompt, condition=nil)
  #when you just need a response from the user
  #condition can be alpha, number, or nil
  active = 1
  while active == 1 do
    puts prompt
    user_response = STDIN.gets.chomp
    case
    when condition == nil
      active = 0
      return user_response.strip
    when condition == "alpha" && user_response.match(/^[[:alpha:]]+$/) != nil
      active = 0
      return user_response.strip
    when condition == "number" && user_response.to_i != nil
      active = 0
      return user_response.to_i
    when user_response.downcase == "quit" || "exit"
      active = 0
      exit
    else
      puts "No special characters please!"
      get_input(prompt, condition)
    end
  end
end

def program_open
  prompt = "\nWelcome! Enter 'Eat' to begin searching for delicous food or 'Quit' to logout and quit the program.\n"
  cases = {"eat" => user_entry}
  flexible_menu(prompt, cases)
end

def user_entry
  prompt = "\nPlease login by entering your first name:\n"
  condition = "alpha"
  user = User.find_or_create_by(name: get_input(prompt, condition))
  puts "\nYou are now logged in as #{user.name}\n"
  user_menu(user)
end

def user_menu(user)
  prompt = "\n#{user.name}, what would you like to do? Enter 'See Reviews', 'Search' or 'Quit' to logout.\n"
  cases = {"see reviews" => user.pretty_reviews,
           "search" => food_search,
           format: "string"}
  flexible_menu(prompt, cases)
end

def food_search
  prompt = "\nEnter a neighborhood or city name\n"
  condition = "alpha"
  location = get_input(prompt, condition)
  choose_location(location)
end

def choose_location(location)
  array_of_options = match_input_to_location(location)
  suggestions_menu = location_suggestions(array_of_options)
  pretty_hash = pretty_location_menu(suggestions_menu, array_of_options)
  display_pretty_hash(pretty_hash)

  prompt = "\nEnter the number of the location you would like\n"
  condition = "number"
  number = get_input(prompt, condition)

  chosen_location = pretty_hash[number].values[0]
  get_cuisines(chosen_location, array_of_options)
end

def display_pretty_hash(hash)
  hash.each do |key, value|
    print "#{key}: "
    value.each {|key, value| puts key}
  end
  puts
end

def get_cuisines(chosen_location, array_of_options)
  array_of_restaurants = search_area_for_restaurants(array_of_options[chosen_location])
  hash_of_cuisines = most_occuring_cuisines(array_of_restaurants)

  ## this should be refactored to use pretty_hash and
  ## display_pretty_hash and get_input

  count = 1
  hash_of_cuisines.each do |key,value|
    puts "#{count}. #{key} (#{value} restaurant(s))"
    count += 1
  end
  puts "Choose which cuisine you would like"
  cuisine = STDIN.gets.chomp.to_i
  binding.pry
end
