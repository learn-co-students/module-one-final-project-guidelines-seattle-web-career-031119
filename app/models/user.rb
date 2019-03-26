class User < ActiveRecord::Base
  has_many :list_items
  has_many :meals
  has_many :recipes, through: :meals

  ACTIONS = ["cook", "remove", "shoplist"]

  def print_recipe_options
    puts "================================="
    puts "Please select one:"
    recipes.each_with_index do |recipe, i|
      puts "#{i+1}. #{recipe.title}"
    end
    puts "=================================="
  end

  def get_active_meals
    meals.select {|meal| meal.active == true}
  end

  def print_active_meals
    puts "================================="
    puts "Please select one:"
    get_active_meals.each_with_index do |meal, i|
      puts "#{i+1}. #{meal.recipe.title}"
    end
    puts "=================================="
  end

  def print_meals
    meals.reset
    puts "=================================="
    meals.each_with_index do |meal, index|
      puts "#{index+1}. #{meal.recipe.title}\t\t#{meal.active == false ? "Cooked" : "Awaiting Cooking"}"
    end
  end

  def perform(action)
    parsed_actions = action.split(" ")
    index = parsed_actions[1].to_i - 1
    if parsed_actions.count != 2 || !ACTIONS.include?(parsed_actions[0])
      puts "Invalid command."
      return
    end

    case parsed_actions[0]
    when "cook"
      puts "Setting #{meals[index].recipe.title} to awaiting cooking!\n\n"
      meals[index].update(active: true)
    when "remove"
      puts "Removing #{meals[index].recipe.title} from your saved meals.\n\n"
      meals[index].delete
    when "shoplist"
      puts "FUNCTIONALITY NOT YET IMPLEMENTED"
    end
  end

  def get_recipe_by_choice(choice)
    get_active_meals[choice].recipe
  end

  def set_cooked(choice)
    get_active_meals[choice].update(active: false)
  end

  def print_ingredient_list
    puts "=========SHOPPING LIST============"
    recipes.each do |recipe|
        name = Ingredient.where(recipe_id: recipe.id).pluck(:name)
        amount = Ingredient.where(recipe_id: recipe.id).pluck(:amount)
        unit = Ingredient.where(recipe_id: recipe.id).pluck(:unit)

        puts "#{amount} #{unit}:  #{name}"
    end
  end

end
