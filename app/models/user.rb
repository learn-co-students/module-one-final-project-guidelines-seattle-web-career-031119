class User < ActiveRecord::Base
  has_many :list_items
  has_many :meals
  has_many :recipes, through: :meals

  ACTIONS = ["cook", "remove", "shoplist"]

  def print_recipe_options
    puts sepparator_line
    puts "Please select one:"
    recipes.each_with_index do |recipe, i|
      puts "#{i+1}. #{recipe.title}"
    end
    puts sepparator_line
  end

  def get_active_meals
    meals.select {|meal| meal.active == true}
  end

  def print_active_meals
    puts sepparator_line
    puts Paint["Please select a recipe to cook:", :black, :bold]
    table = []
    get_active_meals.each_with_index do |meal, i|
      table << {Index: i+1, Title: meal.recipe.title}
    end
    Formatador.display_table(table)
    puts sepparator_line
  end

  def print_meals
    meals.reset
    puts sepparator_line
    table = []
    meals.each_with_index do |meal, index|
      table << {
        Index: index+1,
        Title: meal.recipe.title,
        Status: meal.active == false ? "Cooked" : "Awaiting Cooking"
      }
    end
    Formatador.display_table(table, [:Index, :Title, :Status])
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

  def get_ingredient_list
    ingredient_array = []
    recipes.each do |recipe|
      ingredient_array << recipe.ingredients
    end
    ingredient_array_flatten = ingredient_array.flatten
    puts "========Ingredient List=========="
    ingredient_array_flatten.each do |ingredient|
      puts "#{ingredient.amount} #{ingredient.unit} - #{ingredient.name.upcase}"
    end
    puts "==============================="
    puts "=======HAPPY SHOPPING!========="
    puts "==============================="

  end


end
























      #)))
