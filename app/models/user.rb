class User < ActiveRecord::Base
  has_many :list_items
  has_many :meals
  has_many :recipes, through: :meals


  def print_recipe_options
    puts "================================="
    puts "Please select one:"
    recipes.each_with_index do |recipe, i|
      puts "#{i+1}. #{recipe.title}"
    end
    puts "=================================="
  end

  def get_recipe_by_choice(choice)
    recipes[choice]
  end

end
