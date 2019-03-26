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
    self.find_or_create_player(username)
  end

  def self.find_or_create_player(username)
    player_exists = Player.find_by(username: username)
    if player_exists
      @player = player_exists
      puts "Welcome back, #{@player.username}!"
    else
      @player = Player.create(username: username)
    end
  end

  def self.begin_game
    @current_game = Game.create
    round_counter = 1

    while round_counter < 4
      self.a_single_round
      round_counter +=1
    end
  end

  def self.a_single_round
    Round.create(game_id: current_game.id, player_id: @player.id)
    lyric_index = rand(0...Lyric.count)
    Lyric.find()

  end
end

binding.pry
0
