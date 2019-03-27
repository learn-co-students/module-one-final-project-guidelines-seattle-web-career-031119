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
      player = self.create(username: username)
      puts "Welcome, #{player.username}!"
      puts
    end
  end

  def get_player_scores
    games = self.games.uniq
    games.collect do |game|
      game.get_game_score
    end
  end

  def get_players_avg_score
    total = self.get_player_scores.inject(0) {|score, sum| sum + score}
    (total.to_f / self.games.uniq.count).round(2)
  end
end
