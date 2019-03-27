def make_review(chosen_restaurant)
  ## chosen_restaurant = string of restaurant name
  ##-----------------------------------------------
  ## prompt user for resto's rating
  puts "How many stars would you give this restaurant? (1-5)"
  ## extra : control input format?
  star_rating = get.strip.to_i
  ## prompt user for review message
  puts "Please write a brief review"
  review_message = get.strip

  restaurant = Restaurant.create(name: chosen_restaurant)
  review = Review.create(user: @@user, restaurant: restaurant, rating: star_rating, message: review_message)


end


puts make_review("the thai place")
