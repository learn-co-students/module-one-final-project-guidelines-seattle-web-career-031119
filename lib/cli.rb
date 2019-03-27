require_relative '../config/environment.rb'

class Cli
  attr_accessor :username

  def self.welcome_message
    puts
    puts "Welcome to the 90's Song Quiz!"
    puts "How well do YOU know the 90's?"
    puts
  end

  def self.get_username
    puts "Please enter your username:"
    username = gets.chomp
    @player = Player.find_or_create_player(username)
  end

  def self.start_a_game
    current_game = Game.create
    round_counter = 1
    songs_already_chosen =[]

    while round_counter <= 4
      lyric_i = rand(1..Lyric.count)
      songs_already_chosen << lyric_i
      self.a_single_round(lyric_i, current_game)
      round_counter +=1
    end
  end

  def self.get_random_artist(remaining_lyric_i)
    rand_index = remaining_lyric_i.sample
    @remaining_lyric_i.delete(rand_index)
    rand_index
  end

  def self.a_single_round(lyric_i, current_game)
    round = Round.create(game_id: current_game.id, player_id: @player.id, score: 0)
    @remaining_lyric_i = (1..Lyric.count).collect {|x| x}
    @remaining_lyric_i.delete(lyric_i)

    guess_this_lyric = Lyric.find(lyric_i)
    puts "Which artist wrote this lyric?"
    puts "#{guess_this_lyric[:most_lyric]}"
    puts
    correct_answer = self.display_options(lyric_i)
    puts
    user_answer = gets.chomp
    if user_answer.downcase == correct_answer
      puts "You got it!"
      round.score = 5
    else
      puts "Not quite dude!"
    end
    puts
  end

  def self.display_options(lyric_i)
    answer_options_array = self.randomize_answers(lyric_i)
    (0..3).each {|i| puts answer_options_array[i]}
    answer_options_array[4]
  end

  def self.randomize_answers(lyric_i)
    answer_options_array =['a. ', 'b. ', 'c. ' , 'd. ']
    answer_options_remaining = [0, 1, 2, 3]
    while answer_options_remaining.count > 1
      this_index = answer_options_remaining.sample
      answer_options_array[this_index] << "#{Lyric.find(self.get_random_artist(@remaining_lyric_i))[:artist_name]}"
      answer_options_remaining.delete(this_index)
    end
    answer_options_array[answer_options_remaining[0]] << "#{Lyric.find(lyric_i)[:artist_name]}"
    answer_options_array << answer_options_array[answer_options_remaining[0]][0]
    answer_options_array
  end
end
