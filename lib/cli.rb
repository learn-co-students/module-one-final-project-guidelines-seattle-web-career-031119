require_relative '../config/environment.rb'

def welcome_message
  puts
  puts "Welcome to the 90's Song Quiz!"
  puts "How well do YOU know the 90's?"
  puts
end

def get_username
  puts "Please enter your username:"
  username = gets.chomp
  find_or_create_player(username)
end

def find_or_create_player(username)
  player_exists = Player.find_by(username: username)
  if player_exists
    player = player_exists
    puts "Welcome back, #{player.username}!"
  else
    player = Player.create(username: username)
  end
end

def begin_game
  
end

# binding.pry
# 0
