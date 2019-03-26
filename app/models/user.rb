class User < ActiveRecord::Base

  has_many :reviews
  has_many :restaurants, through: :reviews


#mera's to do def pretty_reviews

  def reviewed_restaurants
    puts "You have reviewed the following restaurants:"
    x = self.reviews.collect {|review|
      review.restaurant.name
    }
    x.each_with_index {|restaurant, index|
      puts "#{index+1}. #{restaurant}"
    }
  end

  def review_of_restaurant(restaurant_name)
    puts "Your review of #{restaurant_name}"
    x = self.reviews.find {|review|
      review.restaurant.name == restaurant_name
    }
    puts "Your rating: #{x.rating}"
    puts "Your review: #{x.message}"
  end



end
