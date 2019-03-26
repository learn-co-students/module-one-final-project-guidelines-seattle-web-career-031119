class Recipe < ActiveRecord::Base
  has_many :meals
  has_many :steps
  has_many :ingredients
  has_many :users, through: :meals

end
