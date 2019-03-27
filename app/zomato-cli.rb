## All these methods should be split up into classes and separate files today

## --------------------------------------
## API METHODS
## --------------------------------------

def api_key
  "4e444090a6cc15f3ea6a678736291ab3"
end

def api_connect(query_url)
  url_string = "https://developers.zomato.com/api/v2.1/" + query_url
  binding.pry
  response_string = RestClient::Request.execute(method: :get,
    url: url_string,
    headers: {"user-key": api_key},
    timeout: 10)
    JSON.parse(response_string)
  end

  def api_location_suggestions(location)
    # Takes the user's location query and returns the API's location suggestions.
    api_connect("locations?query=#{location}&count=10")["location_suggestions"]
  end

  def api_get_restaurants_from_location(location_hash)
    # Once user has selected a location, first get x pages of restaurant results
    # from that city (results), and return as an array of restaurant hashes.
    # We get 20 results per page. Change "number".times to process multiple pages.
    restaurants = []
    1.times do |page|
      results = api_connect("search?entity_id=#{location_hash["entity_id"]}&entity_type=#{location_hash["entity_type"]}&start=#{(page-1)*20}")
      results["restaurants"].map {|rest| restaurants << rest}
    end
    restaurants
  end

## ------------------------------------
## MENU HELPER METHODS
## ------------------------------------

def multiple_choice_menu(prompt, choices)
  # Use when we need the user to choose from options.
  # Choices comes in as a hash (choices), with the user input as keys
  # and the action as values.  If you want to limit user input,
  # add ":format => 'alpha'" or ":format => 'number'"
  active = 1
  while active == 1 do
    puts prompt
    case choices[:format]
    when "alpha"
      user_response = STDIN.gets.chomp.downcase
    when "number"
      user_response = STDIN.gets.chomp.to_i
    else
      user_response = STDIN.gets.chomp.downcase
    end

    case
    when choices.keys.include?(user_response)
      active = 0
      choices[user_response]
    when user_response == 'quit' || 'exit'
      active = 0
      exit
    else
      puts "Sorry, I didn\'t understand."
    end
  end
end

def get_input(prompt, condition=nil)
  # Use to get a response from the user.
  # Condition can be "alpha" (alphabetical), "number", or nil.
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
      if condition == "alpha"
        puts "No special characters please!"
      elsif condition == "number"
        puts "Only numbers please!"
      end
      get_input(prompt, condition)
    end
  end
end

## ------------------------------------
## CLI/USER INTERACTIVE METHODS
## ------------------------------------

def program_open
  prompt = "\nWelcome! Enter 'Eat' to begin searching for delicous food,\nor 'Quit' to logout and quit the program.\n"
  choices = {"eat" => user_entry}
  multiple_choice_menu(prompt, choices)
end

def user_entry
  prompt = "\nPlease login by entering your first name:\n"
  condition = "alpha"
  username = get_input(prompt, condition)
  user = User.find_or_create_by(name: username)
  puts "\nYou are now logged in as #{user.name.capitalize}\n"
  user_menu(user)
end

def user_menu(user)
  prompt = "\n#{user.name.capitalize}, what would you like to do?\nEnter 'See Reviews', 'Search' or 'Quit' to logout.\n"
  choices = {"see reviews" => user.pretty_reviews,
           "search" => food_search,
           format: "alpha"}
  multiple_choice_menu(prompt, choices)
end

def food_search
  prompt = "\nEnter a neighborhood or city name\n"
  condition = "alpha"
  location = get_input(prompt, condition)
  choose_location(location)
end

def choose_location(location)
  array_of_options = api_location_suggestions(location)
  suggestions_menu = location_menu_prep(array_of_options)
  pretty_hash = pretty_location_menu(suggestions_menu, array_of_options)
  display_pretty_hash(pretty_hash)

  prompt = "\nEnter the number of the location you would like\n"
  condition = "number"
  number = get_input(prompt, condition)

  chosen_location = pretty_hash[number].values[0]
  get_cuisines(chosen_location, array_of_options)
end

def get_cuisines(chosen_location, array_of_options)
  array_of_restaurants = api_get_restaurants_from_location(array_of_options[chosen_location])
  hash_of_cuisines = most_occuring_cuisines(array_of_restaurants)

  ## below should be refactored to use pretty_hash and
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

## ------------------------------------
## DATA PROCESSING METHODS
## ------------------------------------

def display_pretty_hash(hash)
  hash.each do |key, value|
    prnumber "#{key}: "
    value.each {|key, value| puts "#{key}\n"}
  end
end

def location_menu_prep(locations)
  # Filters out non-US locations and returns an array of indexes to the
  # locations from the api_location_suggestions hash
  suggestions_menu = []
  locations.each_with_index do |loc, i|
    if loc["country_id"] == 216
      suggestions_menu << i
    end
  end
  suggestions_menu
end

def pretty_location_menu(suggestions_menu, locations)
  # Takes the suggestions menu index
  loc_menu_output = Hash.new
  menu_number = 1
  suggestions_menu.map do |itemno|
    #puts "#{menu_number}. #{locations[itemno]['title']}"
    loc_menu_output[menu_number] = {locations[itemno]['title'] => itemno}
    menu_number += 1
  end
  loc_menu_output
end

def most_occuring_cuisines(restaurants)
  # Take in a hash of restaurants and make a hash of cuisines (keys) and frequency (values)
  cuis_hash = Hash.new(0)
  restaurants.map do |res|
    cuisine_array = []
    cuisine_array = res["restaurant"]["cuisines"].split(", ")
    cuisine_array.map {|c| cuis_hash[c] += 1 }
  end
  # Sorts hash by values, turning it into an array and back
  cuis_hash.sort { |l, r| r[1]<=>l[1] }.to_h
end
