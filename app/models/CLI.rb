class CLI

  @@user = nil
  @@location = nil
  @@cuisine = nil
  @@restaurant = nil
  @@restaurants = nil
  @@restaurants_master_list = nil
  @@reviews_hash = nil

  ## ------------------------------------
  ## MENU HELPER METHODS
  ## ------------------------------------

  def self.main_menu(prompt)
    active = 1
    dashes = ''

    while active == 1
        self.display_prompt(prompt)
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

              when "quit"
                active = 0
                exit

              else
                puts "\nI am not smart enough to understand that. Please enter a valid command.\n"
              end

        else
          puts "\nPlease enter a command that does not contain special characters.\n"
        end

    end

  end

  def self.prompt_hash
    {
      "search" => "Start a new search",
      "logout" => "Log out of your account",
      "back" => "Go back to restaurants list",
      "review" => "Create a review of this restaurant",
      "see reviews" => "See all of your reviews",
      "update review" => "Update one of your reviews",
      "delete review" => "Delete one of your reviews",
      "quit" => "Leave I guess"
    }
  end

  def self.display_prompt(prompt)
    prompt << "quit"
    puts "—" * 80
    puts "Would you like to:"
    prompt.each do |line|
      puts "\t#{line}:" + " "*(20-line.length) + "#{prompt_hash[line]}"
    end
    puts "—" * 80
  end

  def self.menu_get_input(prompt, condition=nil)
    # Use to get a response from the user.
    # Condition can be "alpha" (alphabetical), "number", or nil.
    active = 1
    while active == 1 do
      puts "\n#{prompt}"
      user_response = STDIN.gets.chomp
      case
      when condition == nil
        active = 0
        return user_response.strip
      when condition == "alpha" && user_response.match(/^[\w\s]+$/) != nil
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
        active = 0
        #menu_get_input(prompt, condition)
      end
    end
  end

  ## ------------------------------------
  ## CLI/USER INTERACTIVE METHODS
  ## ------------------------------------

  def self.start
    puts "\nWelcome to 'Eat or Quit' our Zomato based CLI!\n"
    self.user_entry
  end

  def self.user_entry
    prompt = "\nPlease login by entering your first name:\n"
    condition = "alpha"
    username = self.menu_get_input(prompt, condition)
    @@user = User.find_or_create_by(name: username)
    puts "\nYou are now logged in as #{@@user.name.capitalize}\n"
    #self.user_menu
    self.main_menu(["search", "see reviews", "logout"])
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
    @@location = location_options_array[chosen_location_index]
    self.get_cuisines
  end

  def self.get_cuisines
    @@restaurants_master_list = API.get_restaurants_from_location(@@location)
    hash_of_cuisines = Processor.most_occuring_cuisines(@@restaurants_master_list)

    hash_of_cuisines.each do |key, value|
      print "#{key}: "
      value.each {|key, value| puts "#{key} - #{value} restaurant(s)\n"}
    end

    prompt = "Choose which cuisine you would like"
    condition = "number"
    chosen_cuisine_number = self.menu_get_input(prompt, condition)

    @@cuisine = hash_of_cuisines[chosen_cuisine_number].keys[0]
    self.get_restaurants
  end

  def self.get_restaurants
    @@restaurants = @@restaurants_master_list.select {|rest| rest["restaurant"]["cuisines"].include?(@@cuisine)}
    @@restaurants.sort_by! { |r| r["restaurant"]["user_rating"]["aggregate_rating"].to_f*-1 }
    restaurants_menu_hash = Hash.new
    @@restaurants.each.with_index(1) do |rest, index|
      restaurants_menu_hash[index] = {rest["restaurant"]["name"] => rest["restaurant"]["user_rating"]["aggregate_rating"]}
    end
    restaurants_menu_hash.each do |key, value|
      print "#{key}: "
      value.each {|key, value| puts "#{key}, (#{value} avg rating)\n"}
    end
    #needs to make multiple choice: "new search", "review one of the above rests"
    prompt = "Choose a number to review a restaurant"
    condition = "number"
    restaurant_number = self.menu_get_input(prompt, condition)

    @@restaurant = @@restaurants.find{|r| r['restaurant']['name'] == restaurants_menu_hash[restaurant_number].keys[0]}
    self.pick_restaurant
  end

  def self.pretty_restaurant_data
    ["—"*80,
     "Restaurant:                  #{@@restaurant['restaurant']['name']}",
     "—"*80,
     "Cuisine(s):                  #{@@restaurant['restaurant']['cuisines']}",
     "Average Rating:              #{@@restaurant['restaurant']['user_rating']['aggregate_rating']}",
     "Locality:                    #{@@restaurant['restaurant']['location']['locality']}",
     "Price Range:                 " + '$'*@@restaurant['restaurant']['price_range'].to_i,
     "Average Cost for Two:        $#{@@restaurant['restaurant']['average_cost_for_two'].to_i}",
     "Address:                     #{@@restaurant['restaurant']['location']['address']}"
  ]
  end

  def self.pick_restaurant
    pretty_restaurant_data = self.pretty_restaurant_data
    pretty_restaurant_data.each {|line| puts "#{line}"}
    main_menu(["review", "back", "search", "logout"])
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
