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

        if user_response.match(/^[\w\s]+$/) != nil #check if special characters are present in user input
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
                self.delete_review

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
