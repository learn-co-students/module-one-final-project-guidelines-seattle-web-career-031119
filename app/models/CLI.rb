class CLI

  @@user = nil

  ## ------------------------------------
  ## MENU HELPER METHODS
  ## ------------------------------------

  def self.main_menu(prompt)
    active = 1
    dashes = ''

    while active == 1
        length_of_prompt = prompt.length + 44
        length_of_prompt.times {|x| dashed = dashes + '-'}
        puts "\n"+ "-"*length_of_prompt
        puts "#{prompt} Enter 'logout' to return to the login menu."
        puts "-"*length_of_prompt + "\n"
        user_response = STDIN.gets.chomp
        user_response.downcase!
        user_response.strip!

        if user_response.match(/^[[:alpha:]]+$/) != nil #check if special characters are present in user input
              case user_response

              when "logout"
                active = 0
                puts "\nOK, see you later #{@@user.name.capitalize}!\n"
                @@user = nil
                self.user_entry

              when "search"
                active = 0
                self.food_search

              when "back"
                active = 0
                self.get_restaurants

              when "review"
                active = 0
                self.create_review

              when "see reviews"
                active = 0
                self.read_reviews

              when "update review"
                active = 0
                self.update_review

              when "delete review"
                active = 0
                @@user.delete_review

              else
                puts "\nI am not smart enough to understand that. Please enter a valid command.\n"
              end

        else
          puts "\nPlease enter a command that does not contain special characters.\n"
        end

    end

  end

  def self.menu_get_input(prompt, condition=nil)
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
        menu_get_input(prompt, condition)
      end
    end
  end

  ## ------------------------------------
  ## CLI/USER INTERACTIVE METHODS
  ## ------------------------------------

  def self.start
    prompt = "\nWelcome! Enter 'Eat' to begin searching for delicous food,\nor 'Quit' to logout and quit the program.\n"
    choices = {"eat" => user_entry}
    # menu_multiple_choice(prompt, choices)
    self.user_entry
  end

  def self.user_entry
    prompt = "\nPlease login by entering your first name:\n"
    condition = "alpha"
    username = self.menu_get_input(prompt, condition)
    @@user = User.find_or_create_by(name: username)
    puts "\nYou are now logged in as #{@@user.name.capitalize}\n"
    #self.user_menu
    self.main_menu("I don't know what to do AHHHHHHH panicing!!!!")
  end

  def self.user_menu
    prompt = "\n#{@@user.name.capitalize}, what would you like to do?\nEnter 'See Reviews', 'Search' or 'Quit' to logout.\n"
    # #binding.pry
    # choices = {"see reviews" => 'user.pretty_reviews',
    #          "search" => 'food_search',
    #          format: "alpha"}
    # menu_multiple_choice(prompt, choices)

    puts prompt
    puts "This is not working yet, going to food_search"
    # user.pretty_reviews
    self.food_search
  end

  def self.food_search
    prompt = "\nEnter a neighborhood or city name\n"
    condition = "alpha"
    location = self.menu_get_input(prompt, condition)
    self.choose_location(location)
  end

  def self.choose_location(location)
    location_options_array = API.location_suggestions(location)
    location_suggestions_hash = Processor.location_menu_prep(location_options_array)
    pretty_location_hash = Processor.pretty_location_menu(location_suggestions_hash, location_options_array)
    Processor.display_pretty_location_hash(pretty_location_hash)

    prompt = "\nEnter the number of the location you would like\n"
    condition = "number"
    number = self.menu_get_input(prompt, condition)

    chosen_location_index = pretty_location_hash[number].values[0]
    chosen_location = location_options_array[chosen_location_index]
    self.get_cuisines(chosen_location)
  end

  def self.get_cuisines(chosen_location)
    array_of_restaurants = API.get_restaurants_from_location(chosen_location)
    hash_of_cuisines = Processor.most_occuring_cuisines(array_of_restaurants)

    hash_of_cuisines.each do |key, value|
      print "#{key}: "
      value.each {|key, value| puts "#{key} - #{value} restaurant(s)\n"}
    end

    prompt = "Choose which cuisine you would like"
    condition = "number"
    chosen_cuisine_number = self.menu_get_input(prompt, condition)
    chosen_cuisine = hash_of_cuisines[chosen_cuisine_number].keys[0]
    self.get_restaurants(chosen_cuisine, array_of_restaurants)
  end

  def self.get_restaurants(chosen_cuisine, array_of_restaurants)
    restaurants_matching_cuisine = array_of_restaurants.select {|rest| rest["restaurant"]["cuisines"].include?(chosen_cuisine)}
    restaurants_matching_cuisine = restaurants_matching_cuisine.sort { |l, r| r["restaurant"]["user_rating"]["aggregate_rating"] <=> l["restaurant"]["user_rating"]["aggregate_rating"] }
    # binding.pry
    matching_restaurants_hash = Hash.new
    restaurants_matching_cuisine.each.with_index(1) do |rest, index|
      matching_restaurants_hash[index] = {rest["restaurant"]["name"] => rest["restaurant"]["user_rating"]["aggregate_rating"]}
    end
    matching_restaurants_hash.each do |key, value|
      print "#{key}: "
      value.each {|key, value| puts "#{key}, Average Rating: #{value}\n"}
    end
    #needs to make multiple choice: "new search", "review one of the above rests"
    prompt = "Choose a number to review a restaurant"
    condition = "number"
    restaurant_number = self.menu_get_input(prompt, condition)

    chosen_restaurant = matching_restaurants_hash[restaurant_number].keys[0]
    # binding.pry
    self.make_review(chosen_restaurant)
  end

  def self.make_review(chosen_restaurant)
    ## Needs to be written
  end

end
