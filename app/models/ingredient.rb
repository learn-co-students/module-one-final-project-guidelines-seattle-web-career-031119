class Ingredient < ActiveRecord::Base
  belongs_to :recipe


  def self.create_from_data(data, recipe_id)
    self.create({
      recipe_id: recipe_id,
      aisle: data['aisle'],
      name: data['name'],
      amount: data['amount'],
      unit: data['unit'],
      full_name: data['originalString'],
      external_id: data['id']
      })
  end

end
