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

  def self.leaderboard
    top_players_hash ={}
    self.all.each {|player| top_players_hash[player] = player.get_player_high_score}
    sorted_arr = top_players_hash.sort_by {|key, value| value}.reverse

    self.count < 5 ? leader_index = self.count : leader_index = 5
    return_hash = {}
    (0...leader_index).each do |num|
      return_hash[sorted_arr[num][0].username] = sorted_arr[num][1]
    end
    return_hash
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

  def get_player_high_score
    self.get_player_scores.max
  end
end
