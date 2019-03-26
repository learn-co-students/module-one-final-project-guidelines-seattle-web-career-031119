class AddExternalIdToIngredients < ActiveRecord::Migration[5.0]
  def change
    add_column :ingredients, :external_id, :integer
  end
end
