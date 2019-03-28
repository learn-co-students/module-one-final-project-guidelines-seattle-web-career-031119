# ## All these methods should be split up into classes and separate files today
#
# ## --------------------------------------
# ## API METHODS
# ## --------------------------------------
#
# def api_key
#   "4e444090a6cc15f3ea6a678736291ab3"
# end
#
# def api_connect(query_url)
#   url_string = "https://developers.zomato.com/api/v2.1/" + query_url
#   response_string = RestClient::Request.execute(method: :get,
#     url: url_string,
#     headers: {"user-key": api_key},
#     timeout: 10)
#     JSON.parse(response_string)
#   end
#
#   def api_location_suggestions(location)
#     # Takes the user's location query and returns the API's location suggestions.
#     api_connect("locations?query=#{location}&count=10")["location_suggestions"]
#   end
#
#   def api_get_restaurants_from_location(location_hash)
#     # Once user has selected a location, first get x pages of restaurant results
#     # from that city (results), and return as an array of restaurant hashes.
#     # We get 20 results per page. Change "number".times to process multiple pages.
#     restaurants = []
#     1.times do |page|
#       results = api_connect("search?entity_id=#{location_hash["entity_id"]}&entity_type=#{location_hash["entity_type"]}&start=#{(page-1)*20}")
#       results["restaurants"].map {|rest| restaurants << rest}
#     end
#     restaurants
#   end
#
# ## ------------------------------------
# ## MENU HELPER METHODS
# ## ------------------------------------
#
# def menu_multiple_choice(prompt, choices)
#   # Use when we need the user to choose from options.
#   # Choices comes in as a hash (choices), with the user input as keys
#   # and the action as values.  If you want to limit user input,
#   # add ":format => 'alpha'" or ":format => 'number'"
#
#   # REFACTOR TO CASE/WHEN
#   active = 1
#   while active == 1 do
#     puts prompt
#     case choices[:format]
#     when "alpha"
#       user_response = STDIN.gets.chomp.downcase
#     when "number"
#       user_response = STDIN.gets.chomp.to_i
#     else
#       user_response = STDIN.gets.chomp.downcase
#     end
#
#     case
#     when choices.keys.include?(user_response)
#       active = 0
#       #eval(choices[user_response])
#     when user_response == 'quit' || 'exit'
#       active = 0
#       exit
#     else
#       puts "Sorry, I didn\'t understand."
#     end
#   end
# end
#
# def menu_get_input(prompt, condition=nil)
#   # Use to get a response from the user.
#   # Condition can be "alpha" (alphabetical), "number", or nil.
#   active = 1
#   while active == 1 do
#     puts prompt
#     user_response = STDIN.gets.chomp
#     case
#     when condition == nil
#       active = 0
#       return user_response.strip
#     when condition == "alpha" && user_response.match(/^[[:alpha:]]+$/) != nil
#       active = 0
#       return user_response.strip
#     when condition == "number" && user_response.to_i != nil
#       active = 0
#       return user_response.to_i
#     when user_response.downcase == "quit" || "exit"
#       active = 0
#       exit
#     else
#       if condition == "alpha"
#         puts "No special characters please!"
#       elsif condition == "number"
#         puts "Only numbers please!"
#       end
#       menu_get_input(prompt, condition)
#     end
#   end
# end
#
# ## ------------------------------------
# ## CLI/USER INTERACTIVE METHODS
# ## ------------------------------------
#
# def program_open
#   prompt = "\nWelcome! Enter 'Eat' to begin searching for delicous food,\nor 'Quit' to logout and quit the program.\n"
#   choices = {"eat" => user_entry}
#   menu_multiple_choice(prompt, choices)
# end
#
# def user_entry
#   prompt = "\nPlease login by entering your first name:\n"
#   condition = "alpha"
#   username = menu_get_input(prompt, condition)
#   user = User.find_or_create_by(name: username)
#   puts "\nYou are now logged in as #{user.name.capitalize}\n"
#   user_menu(user)
# end
#
# def user_menu(user)
#   prompt = "\n#{user.name.capitalize}, what would you like to do?\nEnter 'See Reviews', 'Search' or 'Quit' to logout.\n"
#   # #binding.pry
#   # choices = {"see reviews" => 'user.pretty_reviews',
#   #          "search" => 'food_search',
#   #          format: "alpha"}
#   # menu_multiple_choice(prompt, choices)
#
#   puts prompt
#   puts "This is not working yet, going to food_search"
#   # user.pretty_reviews
#   food_search
# end
#
# def food_search
#   prompt = "\nEnter a neighborhood or city name\n"
#   condition = "alpha"
#   location = menu_get_input(prompt, condition)
#   choose_location(location)
# end
#
# def choose_location(location)
#   location_options_array = api_location_suggestions(location)
#   location_suggestions_hash = location_menu_prep(location_options_array)
#   pretty_location_hash = pretty_location_menu(location_suggestions_hash, location_options_array)
#   display_pretty_location_hash(pretty_location_hash)
#
#   prompt = "\nEnter the number of the location you would like\n"
#   condition = "number"
#   number = menu_get_input(prompt, condition)
#
#   chosen_location_index = pretty_location_hash[number].values[0]
#   chosen_location = location_options_array[chosen_location_index]
#   get_cuisines(chosen_location)
# end
#
# def get_cuisines(chosen_location)
#   array_of_restaurants = api_get_restaurants_from_location(chosen_location)
#   hash_of_cuisines = most_occuring_cuisines(array_of_restaurants)
#
#   hash_of_cuisines.each do |key, value|
#     print "#{key}: "
#     value.each {|key, value| puts "#{key} - #{value} restaurant(s)\n"}
#   end
#
#   prompt = "Choose which cuisine you would like"
#   condition = "number"
#   chosen_cuisine_number = menu_get_input(prompt, condition)
#   chosen_cuisine = hash_of_cuisines[chosen_cuisine_number].keys[0]
#   get_restaurants(chosen_cuisine, array_of_restaurants)
# end
#
# def get_restaurants(chosen_cuisine, array_of_restaurants)
#   restaurants_matching_cuisine = array_of_restaurants.select {|rest| rest["restaurant"]["cuisines"].include?(chosen_cuisine)}
#   restaurants_matching_cuisine = restaurants_matching_cuisine.sort { |l, r| r["restaurant"]["user_rating"]["aggregate_rating"] <=> l["restaurant"]["user_rating"]["aggregate_rating"] }
#   # binding.pry
#   matching_restaurants_hash = Hash.new
#   restaurants_matching_cuisine.each.with_index(1) do |rest, index|
#     matching_restaurants_hash[index] = {rest["restaurant"]["name"] => rest["restaurant"]["user_rating"]["aggregate_rating"]}
#   end
#   matching_restaurants_hash.each do |key, value|
#     print "#{key}: "
#     value.each {|key, value| puts "#{key}, Average Rating: #{value}\n"}
#   end
#   #needs to make multiple choice: "new search", "review one of the above rests"
#   prompt = "Choose a number to review a restaurant"
#   condition = "number"
#   restaurant_number = menu_get_input(prompt, condition)
#
#   chosen_restaurant = matching_restaurants_hash[restaurant_number].keys[0]
#   binding.pry
#   make_review(chosen_restaurant)
# end
#
# def make_review(chosen_restaurant)
#   new_review = Review.create(user: username)
# end
#
# ## ------------------------------------
# ## DATA PROCESSING METHODS
# ## ------------------------------------
#
# def display_pretty_location_hash(hash)
#   hash.each do |key, value|
#     print "#{key}: "
#     value.each {|key, value| puts "#{key}\n"}
#   end
# end
#
# def location_menu_prep(locations)
#   # Filters out non-US locations and returns an array of indexes to the
#   # locations from the api_location_suggestions hash
#   location_suggestions_hash = []
#   locations.each_with_index do |loc, i|
#     if loc["country_id"] == 216
#       location_suggestions_hash << i
#     end
#   end
#   location_suggestions_hash
# end
#
# def pretty_location_menu(location_suggestions_hash, locations)
#   # Takes the suggestions menu index
#   loc_menu_hash = Hash.new
#   menu_number = 1
#   location_suggestions_hash.map do |itemno|
#     #puts "#{menu_number}. #{locations[itemno]['title']}"
#     loc_menu_hash[menu_number] = {locations[itemno]['title'] => itemno}
#     menu_number += 1
#   end
#   loc_menu_hash
# end
#
# def most_occuring_cuisines(restaurants)
#   # Take in a hash of restaurants and make a hash of cuisines (keys) and frequency (values)
#   cuis_hash = Hash.new(0)
#   restaurants.map do |res|
#     cuisine_array = []
#     cuisine_array = res["restaurant"]["cuisines"].split(", ")
#     cuisine_array.map {|c| cuis_hash[c] += 1 }
#   end
#   # Sorts hash by values, turning it into an array and back
#   cuis_hash = cuis_hash.sort { |l, r| r[1]<=>l[1] }.to_h
#   final_hash = Hash.new
#   cuis_hash.keys.each.with_index(1) do |key, index|
#     final_hash[index] = {key => cuis_hash[key]}
#   end
#   final_hash
# end

# CLI -
#
# - at end of get_restaurants, give options:
#   - pick a restaurant
#   - new search
#
# - pick a restaurant
#   - show
#     -name
#     -cuisine
#     -avg rating
#     -$$$
#     -neighborhood
#   - give options:
#     - back to restaurant list
#     - new search
#     - review
#
# - review a restaurant:
#   get rating
#   get message
#   restaurant.new
#   review.new
#   puts review
#   go to cli.start
#
# - review menu
#   - print all reviews
#     -reviews should have numbered index like the other input hashes
#     -hash should be updated when reviews are changed in any way
#   - update review
#   - delete review
#   - go back to cli.start
#
#
# JON
# - multiple choice menu => case/when
#
# Beginning:
#   - eat / quit
#   - search / reviews
#
# Pick A Restaurant:
#   - new search / back to restaurant list / make a review
#
# Reviews Menu:
#   - update / delete / new search