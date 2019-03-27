class Player < ActiveRecord::Base
  has_many :rounds
  has_many :games, through: :rounds

  def self.find_or_create_player(username)
    player_exists = self.find_by(username: username)
    if player_exists
      puts "Welcome back, #{player_exists.username}!"
      puts
      player_exists
    else
      self.create(username: username)
    end
  end
end
