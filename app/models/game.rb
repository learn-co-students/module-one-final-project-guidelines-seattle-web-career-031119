class Game < ActiveRecord::Base
  has_many :rounds
  has_many :players, through: :rounds
end
