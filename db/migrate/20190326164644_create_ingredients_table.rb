class CreateIngredientsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :ingredients do |t|
      t.integer :recipe_id
      t.string :aisle
      t.string :name
      t.integer :amount
      t.string :unit
      t.string :full_name
    end

  end
end
