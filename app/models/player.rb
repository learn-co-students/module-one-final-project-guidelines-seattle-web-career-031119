class Player < ActiveRecord::Base
  has_many :rounds
  has_many :games, through: :rounds

  def self.find_or_create_player(username)
    player_exists = self.find_by(username: username)
    if player_exists
      puts
      Cli.header
      puts
      puts
      puts "Welcome back, #{player_exists.username}!"
      puts
      player_exists
    else
      puts
      Cli.header
      puts
      puts
      player = self.create(username: username)
      puts "Welcome, #{player.username}!"
      puts
    end
  end

  def self.leaderboard
    averages_hash = {}
    self.all.each {|player| averages_hash[player] = player.get_players_avg_score}
    averages_hash.delete_if {|k, v| v.nan?}

    sorted_arr = averages_hash.sort_by {|key, value| value}.reverse
    sorted_arr.count < 5 ? leader_count = sorted_arr.count : leader_count = 5

    return_arr = []
    (0...leader_count).each do |num|
      return_arr << [[sorted_arr[num][0].username][0], sorted_arr[num][1]]
    end
    return_arr
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
