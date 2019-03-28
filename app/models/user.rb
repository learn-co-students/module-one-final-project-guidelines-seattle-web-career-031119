class User < ActiveRecord::Base
  has_many :list_items
  has_many :meals
  has_many :recipes, through: :meals

  ACTIONS = ["cook", "nocook", "remove", "shoplist", "unshop"]

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

  def get_active_meal_count
    get_active_meals.count
  end

  def has_active_meals?
    get_active_meals.count > 0
  end

  def get_shoplist_meals
    meals.select {|meal| meal.shopping == true}
  end

  def get_shoplist_recipes
    get_shoplist_meals.map(&:recipe)
  end

  def print_active_meals
    puts separator_line
    puts systext("Please select a recipe to cook by entering its index:")
    table = []
    get_active_meals.each_with_index do |meal, i|
      table << {Index: i+1, Title: meal.recipe.title}
    end
    Formatador.display_table(table)
    puts separator_line
  end

  #TODO: Getting the meal object seems like it should be in the meals class.
  def print_meals
    meals.reset
    puts separator_line
    table = TTY::Table.new
    table << ["Index", "Title", "Status", "On Shopping List?", "Rating", "Notes"].map{|item|
      ptext(item)
     }
    meals.each_with_index do |meal, index|
      table << [
        index+1,
        meal.recipe.title,
        meal.active == false ? "Cooked" : "Awaiting Cooking",
        meal.shopping == true ? "Yes" : "No",
        !meal.rating.nil? ? meal.rating.to_5_stars : "[Unrated]",
        !meal.notes.nil? ? meal.notes.max_line_length(50) : "None."
      ]
    end

    putable = table.render(:ascii, multiline: true, padding: [1,1,1,1]) do |renderer|
      renderer.border.separator = TTY::Table::Border::EACH_ROW
    end
    puts putable
  end

  def rate(index)
    loop do
      rating = gets.chomp.to_i
      if rating > 0 && rating <= 5
        get_active_meals[index].update(rating: rating)
        break
      else
        puts "Please enter a number between 1 and 5."
      end
    end
  end

  def annotate(index)
    get_active_meals[index].update(notes: gets.chomp)
  end

  def perform(action)
    parsed_actions = action.split(" ")
    index = parsed_actions[1].to_i - 1
    if parsed_actions.count != 2 || !ACTIONS.include?(parsed_actions[0])
      return "Invalid command.\n\n"
    end

    case parsed_actions[0]
    when "cook"
      meals[index].update(active: true)
      return "Setting #{meals[index].recipe.title} to awaiting cooking!\n\n"
    when "nocook"
      meals[index].update(active: false)
      return "Setting #{meals[index].recipe.title} to cooked.\n\n"
    when "remove"
      meals[index].delete
      return "Removing #{meals[index].recipe.title} from your saved meals.\n\n"
    when "shoplist"
      meals[index].update(shopping: true)
      return "Added #{meals[index].recipe.title} to your shopping list!\n\n"
    when "unshop"
      meals[index].update(shopping: false)
      return "Removed #{meals[index].recipe.title} from your shopping list.\n\n"
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
    get_shoplist_recipes.each do |recipe|
      ingredient_array << recipe.ingredients
    end
    flattened = ingredient_array.flatten.group_by{|ingredients| ingredients.aisle}.sort_by{|key,val| key}
    flattened.each do |aisle, ingredients|
      table = []
      puts "\n\n------- AISLE: #{aisle} -------"
      ingredients.each do |ingredients|
        table << {
          Amount: "#{ingredients.amount} #{ingredients.unit}",
          Name: ingredients.name.upcase
        }
      end
      Formatador.display_table(table)
    end
  end

end
