class CLI

  @@user = nil

  ## ------------------------------------
  ## MENU HELPER METHODS
  ## ------------------------------------

  def self.menu_multiple_choice(prompt, choices)
    # Use when we need the user to choose from options.
    # Choices comes in as a hash (choices), with the user input as keys
    # and the action as values.  If you want to limit user input,
    # add ":format => 'alpha'" or ":format => 'number'"

    # REFACTOR TO CASE/WHEN

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
        #eval(choices[user_response])
      when user_response == 'quit' || 'exit'
        active = 0
        exit
      else
        puts "Sorry, I didn\'t understand."
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
    self.user_menu
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




## REVIEWS METHODS ===========================================================================

## HELPER METHODS --------------------------------------------------------------------------

  def self.print_single_review(review_obj)
    ## prints out the passed review
    puts "\nYour new review: #{review_obj.restaurant.name}"
    puts "\tRating: #{review_obj.rating}"
    puts "\tReview: #{review_obj.message}\n"
  end

  def self.make_review_hash
    #create a hash of all reviews with numerical keys
    @@reviews_hash = {}
    @@user.reviews.each.with_index(1) {|review, index|
      @@reviews_hash[index] = [review.restaurant.name, review.rating, review.message]
    }
  end

  def self.get_rating
    ## prompt user for resto's rating
    prompt = "What would you rate this restaurant? (1-5)"
    menu_get_input(prompt, "number")
  end

  def self.get_message
    ## prompt user for review message
    puts "\nPlease write a brief review."
    STDIN.gets.strip
  end

  def self.find_review_from_user_input(user_input)
    # initialize a blank name
    restaurant_name = ""
    # iterate over pretty hash and find resto name from index number
    @@reviews_hash.each {|key, value|
      if key == user_input
        restaurant_name = value[0]
      end
    }
    #find review by resto name
    @@user.reviews.find {|review|
      review.restaurant.name == restaurant_name
    }
  end

## CRUD METHODS -----------------------------------------------------------------------

  def self.create_review(chosen_restaurant)
    ## chosen_restaurant = string of restaurant name!!!!
    ##-----------------------------------------------
    rating = self.get_rating
    message = self.get_message
    ## make restaurant object and review object and save to our tables
    restaurant = Restaurant.find_or_create_by(name: chosen_restaurant)
    review = Review.create(user: User.all[2], restaurant: restaurant, rating: rating, message: message)
    ## show the user their new review
    self.print_single_review(review)
    ## ask user where they want to go next
    prompt = ["search", "see review", "logout"]
    main_menu(prompt)
  end

  def self.read_reviews
    ## make sure reviews_hash is up to date
    self.make_review_hash
    ## iterate over reviews hash and print them to console
    @@reviews_hash.each {|key, value|
      puts "#{key}: #{value[0]} \n\t Rating: #{value[1]} \n\t Review: #{value[2]}"
      puts "-------------------------------------"
    }
    ## ask user where they want to go next
    prompt = ["search", "update review", "delete review", "logout"]
    main_menu(prompt)
  end

  def self.update_review
    puts "Type number of review you wish to edit"
    review_num = self.menu_get_input(prompt, "number")
    # get the right review from the index the user gave
    review = self.find_review_from_user_input(review_num)
    ## get new rating and message
    rating = self.get_rating
    message = self.get_message
    ## update those fields in the database
    review.update(rating: rating, message: message)
    ##print out new version of review
    self.print_single_review(review)
    ## ask user where they want to go next
    prompt = ["search", "see review", "logout"]
    main_menu(prompt)
  end

  def self.delete_review
    prompt =  "Type number of review you wish to delete"
    review_num = self.menu_get_input(prompt, "number")
    # get the right review from the index the user gave
    review = self.find_review_from_user_input(review_num)
    ## let the user know what they deleted
    puts "You have deleted the following review."
    self.print_single_review(review)
    ## delete it
    review.delete
    ## ask user where they want to go next
    prompt = ["search", "see review", "logout"]
    main_menu(prompt)
  end

end
