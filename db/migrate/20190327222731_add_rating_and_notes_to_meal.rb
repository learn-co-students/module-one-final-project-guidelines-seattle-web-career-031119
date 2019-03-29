class AddRatingAndNotesToMeal < ActiveRecord::Migration[5.0]
  def change
    add_column :meals, :rating, :integer
    add_column :meals, :notes, :string
  end
end
