class User < ActiveRecord::Base
  has_many :list_items
  has_many :meals
  has_many :recipes, through: :meals

  ACTIONS = ["cook", "remove", "shoplist", "unshop"]

  def print_recipe_options
    puts separator_line
    puts "Please select one:"
    recipes.each_with_index do |recipe, i|
      puts "#{i+1}. #{recipe.title}"
    end
    puts separator_line
  end

  def get_active_meals
    meals.select {|meal| meal.active == true}
  end

  def get_shoplist_meals
    meals.select {|meal| meal.shopping == true}
  end

  def get_shoplist_recipes
    get_shoplist_meals.map(&:recipe)
  end

  def print_active_meals
    puts separator_line
    puts Paint["Please select a recipe to cook:", SYSCOLOR, :bold]
    table = []
    get_active_meals.each_with_index do |meal, i|
      table << {Index: i+1, Title: meal.recipe.title}
    end
    Formatador.display_table(table)
    puts separator_line
  end

  def print_meals
    meals.reset
    puts separator_line
    table = []
    meals.each_with_index do |meal, index|
      table << {
        Index: index+1,
        Title: meal.recipe.title,
        Status: meal.active == false ? "Cooked" : "Awaiting Cooking",
        "On Shopping List?": meal.shopping == true ? "Yes" : "No"
      }
    end
    Formatador.display_table(table, [:Index, :Title, :Status, :"On Shopping List?"])
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
      meals[index].update(shopping: true)
    when "unshop"
      meals[index].update(shopping: false)
    end
  end

  def get_recipe_by_choice(choice)
    get_active_meals[choice].recipe
  end

  def set_cooked(choice)
    get_active_meals[choice].update(active: false)
  end

  def get_ingredient_list
    binding.pry
    ingredient_array = []
    recipes.each do |recipe|
      ingredient_array << recipe.ingredients
    end
    flattened = ingredient_array.flatten.group_by{|ingredients| ingredients.aisle}.sort_by{|key,val| key}
    flattened.each do |aisle, ingredients|
      table = []
      puts "\n\n------- AISLE: #{aisle} -------\n\n"
      ingredients.each do |ingredients|
        table << {
          Amount: "#{ingredients.amount} #{ingredients.unit}",
          Name: ingredients.name.upcase
        }
        # puts "#{ingredients.amount} #{ingredients.unit} - #{ingredients.name.upcase}"
      end
      Formatador.display_table(table)
    end
  end

end
