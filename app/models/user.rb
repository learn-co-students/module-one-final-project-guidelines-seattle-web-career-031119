class User < ActiveRecord::Base
  has_many :list_items
  has_many :meals
  has_many :recipes, through: :meals

end
