class Recipe < ActiveRecord::Base
  has_many :meals
  has_many :steps
  has_many :ingredients
  has_many :users, through: :meals

  def walk_through_steps
    steps.each_with_index do |step, index|
      puts "\n\n---------STEP #{index+1}----------------"
      puts "Takes #{step.length}" if !step.length.nil?
      puts step.instructions
      puts "\n\nPress any key to view next step."
      gets
    end
  end

  def self.create_from_data(data)
    recipe = self.create({
      vegetarian: data["vegetarian"],
      vegan: data["vegan"],
      gluten_free: data["glutenFree"],
      dairy_free: data["dairyFree"],
      readyInMinutes: data["readyInMinutes"],
      title: data["title"],
      external_id: data["id"],
      source_url: data["sourceUrl"],
      credit_text: data["creditText"]
    })

    data["extendedIngredients"].each do |ingredient|
      Ingredient.create_from_data(ingredient, recipe.id)
    end

    data["analyzedInstructions"].each do |instruction_set|
      instruction_set["steps"].each do |step|
        Step.create_from_data(step, recipe.id)
      end
    end
    recipe
  end

end
