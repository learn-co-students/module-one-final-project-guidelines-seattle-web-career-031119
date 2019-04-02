class CreateStepsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :steps do |t|
      t.integer :number
      t.string :instructions
      t.string :length
    end
  end
end
