class Recipe < ActiveRecord::Base
  has_many :meals
  has_many :steps
  has_many :ingredients
  has_many :users, through: :meals

end



  def self.create_from_data(data)
    self.create({
      vegetarian: data["vegetarian"],
      vegan: data["vegan"],
      gluten_free: data["glutenFree"],
      dairy_free: data["dairyFree"],
      readyInMinutes: data["readyInMinutes"],
      title: data["title"],
      external_id: data["id"],
      source_url: data["sourceURL"],
      credit_text: data["creditText"]
    })
  end



















  #000
