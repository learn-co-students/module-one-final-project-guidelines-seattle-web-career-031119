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
    @current_game = Game.create
    round_counter = 1
    songs_already_chosen =[]

    while round_counter <= 4
      lyric_i = rand(1..Lyric.count)
      songs_already_chosen << lyric_i
      self.a_single_round(lyric_i)
      round_counter +=1
    end
  end

  def self.get_random_artist(remaining_lyric_i)
    rand_index = remaining_lyric_i.sample
    @remaining_lyric_i.delete(rand_index)
    rand_index
  end

  def self.a_single_round(lyric_i)
    Round.create(game_id: @current_game.id, player_id: @player.id)
    @remaining_lyric_i = (1..Lyric.count).collect {|x| x}
    @remaining_lyric_i.delete(lyric_i)

    guess_this_lyric = Lyric.find(lyric_i)
    puts "Which artist wrote this lyric?"
    puts "#{guess_this_lyric[:most_lyric]}"
    puts
    puts "a. #{Lyric.find(self.get_random_artist(@remaining_lyric_i))[:artist_name]}          | b. #{Lyric.find(self.get_random_artist(@remaining_lyric_i))[:artist_name]}"
    puts "c. #{Lyric.find(lyric_i)[:artist_name]}          | d. #{Lyric.find(self.get_random_artist(@remaining_lyric_i))[:artist_name]}"
    puts
  end
end


0
