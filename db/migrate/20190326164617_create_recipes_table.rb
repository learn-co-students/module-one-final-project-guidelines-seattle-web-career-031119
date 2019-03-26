class CreateRecipesTable < ActiveRecord::Migration[5.0]
  def change
    create_table :recipes do |t|
      t.boolean :vegetarian
      t.boolean :vegan
      t.boolean :gluten_free
      t.boolean :dairy_free
      t.integer :readyInMinutes
      t.string :title
      t.integer :external_id
      t.string :source_url
      t.string :credit_text
    end
  end
end
