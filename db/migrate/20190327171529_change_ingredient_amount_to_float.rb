class ChangeIngredientAmountToFloat < ActiveRecord::Migration[5.0]

  def up
    change_column :ingredients, :amount, :float
  end

  def down
    change_column :ingredients, :amount, :integer
  end
end
