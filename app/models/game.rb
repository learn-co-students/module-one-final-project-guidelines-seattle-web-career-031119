class Game < ActiveRecord::Base
  has_many :rounds
  has_many :players, through: :rounds

  def get_game_score
    scores = Round.where(game_id: self.id).collect {|a_round| a_round[:score]}
    scores.inject(0) {|score, sum| sum + score}
  end

  def start_game(player)
    round_counter = 1
    songs_already_chosen =[]

    while round_counter <= 4
      lyric_i = rand(1..Lyric.count)
      while songs_already_chosen.include?(lyric_i)
        lyric_i = rand(1..Lyric.count)
      end

      songs_already_chosen << lyric_i
      round = Round.create(player_id: player.id, game_id: self.id, score: 0)
      round.start_a_round(lyric_i, self, player, round_counter)
      round_counter +=1
    end

    scores = Round.where(game_id: self.id).collect {|a_round| a_round[:score]}
    puts "-------------------------------"
    puts
    puts "Nice game dude!"
    puts "Your total is: #{scores.inject(0) {|score, sum| sum + score}}"
    puts
    puts "-------------------------------"
  end
end
