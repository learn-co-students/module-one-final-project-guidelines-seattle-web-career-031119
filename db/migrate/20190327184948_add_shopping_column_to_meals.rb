class AddShoppingColumnToMeals < ActiveRecord::Migration[5.0]
  def change
    add_column :meals, :shopping, :boolean
  end
end
