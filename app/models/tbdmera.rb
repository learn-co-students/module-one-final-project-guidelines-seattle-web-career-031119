## REVIEWS METHODS ===========================================================================

## HELPER METHODS --------------------------------------------------------------------------

  def self.print_single_review(review_obj)
    ## prints out the passed review
    puts "\n#{review_obj.restaurant.name}"
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

  def self.create_review
    rating = self.get_rating
    message = self.get_message
    ## make restaurant object and review object and save to our tables
    restaurant = Restaurant.find_or_create_by(name: @@restaurant['restaurant']['name'])
    review = Review.create(user: User.all[2], restaurant: restaurant, rating: rating, message: message)
    ## show the user their new review
    self.print_single_review(review)
    ## ask user where they want to go next
    prompt = ["search", "see reviews", "logout"]
    main_menu(prompt)
  end

  def self.read_reviews
    ## make sure reviews_hash is up to date
    self.make_review_hash
    puts "Your Reviews:\n"
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
    prompt = "Type number of review you wish to edit"
    review_num = self.menu_get_input(prompt, "number")
    # get the right review from the index the user gave
    review = self.find_review_from_user_input(review_num)
    ## get new rating and message
    rating = self.get_rating
    message = self.get_message
    ## update those fields in the database
    review.update(rating: rating, message: message)
    ##print out new version of review
    puts "Your new review:"
    self.print_single_review(review)
    ## ask user where they want to go next
    prompt = ["search", "see reviews", "logout"]
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
    prompt = ["search", "see reviews", "logout"]
    main_menu(prompt)
  end

end
