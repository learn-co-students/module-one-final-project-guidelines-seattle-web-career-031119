class AddRecipeIdToSteps < ActiveRecord::Migration[5.0]
  def change
    add_column :steps, :recipe_id, :integer
  end
end
