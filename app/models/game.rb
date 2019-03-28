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

    while round_counter <= 5
      lyric_i = rand(1..Lyric.count)
      while songs_already_chosen.include?(lyric_i)
        lyric_i = rand(1..Lyric.count)
      end

      songs_already_chosen << lyric_i
      round = Round.create(player_id: player.id, game_id: self.id, score: 0)
      round.start_a_round(lyric_i, round_counter)
      round_counter +=1
    end

    scores = Round.where(game_id: self.id).collect {|a_round| a_round[:score]}
    total_score = scores.inject(0) {|score, sum| sum + score}
    system "clear"
    puts
    puts Cli.header
    puts
    puts "======================================================================"
    puts
    puts Cli.fit_length("Nice game dude!", ' ')
    puts
    puts Cli.fit_length("Your final score is: #{total_score}", ' ')
    puts
    puts "======================================================================"
    puts
    puts
  end
end
