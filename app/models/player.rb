class Player < ActiveRecord::Base
  has_many :rounds
  has_many :games, through: :rounds
end
