require_relative '../config/environment.rb'

class CLI
  attr_accessor :username

  def self.welcome_message
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
    player = Player.find_by(username: username)
    if player
      @player = player
    else
      @player = Player.create(username: username)
    end

  end

end

# binding.pry
# 0
