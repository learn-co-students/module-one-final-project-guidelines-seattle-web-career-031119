#
#
# def menu
#   status = 0
#   while status == 0
#     puts
#     puts "Welcome! Enter 'eat' to begin searching for delicous food around Seattle or 'Quit' to logout and quit the program."
#     puts
#     command = gets.chomp
#     puts
#     if command.downcase == 'eat'
#       status = 1
#       user_entry
#     elsif command.downcase == 'quit'
#       puts 'Ok, see you later.'
#       status = 1
#     else
#       puts "I'm not smart enough to understand your input, so I will return you to the menu :) Thank me later."
#     end
#   end
# end
#
# def user_entry
#   puts
#   puts "Please login by entering your first name:"
#   puts
#   name = gets.chomp
#   while (name.match(/^[[:alpha:]]+$/) == nil)
#     puts
#     puts 'Please enter a user name without special characters!'
#     puts
#     name = gets.chomp
#   end
#   user = User.find_or_create_by(name: name)
#   puts
#   puts "You are now logged in as #{user.name}"
#   puts
#   user_menu(user)
# end
#
# def user_menu(user)
#   status = 0
#   while status == 0
#   puts "#{user.name}, what would you like to do? Enter 'See Reviews', 'Search' or 'Quit' to logout."
#   puts
#   response_string = gets.chomp
#   if response_string.downcase == 'see reviews'
#     user.pretty_reviews
#     puts
#   elsif response_string.downcase == 'search'
#     puts "Enter a neighborhood or city name"
#     puts
#     location = gets.chomp
#     puts
#     location_options_hash = handle_location(location)
#     display_pretty_hash(location_options_hash)
#     puts "Enter the number of the location you would like"
#     puts
#     number = gets.chomp.to_i
#     puts
#
#
#     choosen_location = location_options_hash[number].values[0]
#     array_of_options = match_input_to_location(location)
#     array_of_restaurants = search_area_for_restaurants(array_of_options[choosen_location])
#
#     hash_of_cuisines = most_occuring_cuisines(array_of_restaurants)
#     count = 1
#     hash_of_cuisines.each do |key,value|
#       puts "#{count}. #{key} (#{value} restaurant(s))"
#       count += 1
#     end
#     puts "Choose which cuisine you would like"
#     puts
#     cuisine = gets.chomp.to_i
#
#     binding.pry
#
#   elsif response_string.downcase == 'quit'
#     status = 1
#     menu
#   else
#     puts "I don't know what that means"
#     puts
#   end
#   end
# end
#
#
# def display_pretty_hash(hash)
#   hash.each do |key, value|
#     print "#{key}: "
#     value.each {|key, value| puts key}
#   end
#   puts
# end
#
#
# def handle_location(location)
#   array_of_options = match_input_to_location(location)
#   suggestions_menu = location_suggestions(array_of_options)
#   pretty_hash = pretty_location_menu(suggestions_menu,array_of_options)
# end
