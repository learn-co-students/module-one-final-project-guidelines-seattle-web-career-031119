class CreateListItemsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :list_items do |t|
      t.integer :user_id
      t.boolean :bought
      t.string :aisle
      t.string :ingredient_name
      t.string :ingredient_amount
      t.string :ingredient_unit
    end
  end
end
