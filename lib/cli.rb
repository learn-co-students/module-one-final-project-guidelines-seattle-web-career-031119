require_relative '../config/environment.rb'

class Cli
  attr_accessor :username

  def self.welcome_message
    puts
    puts "Welcome to the 90's Song Quiz!"
    puts "How well do YOU know the 90's?"
    puts
    self.get_username
  end

  def self.get_username
    puts "Please enter your username:"
    @username = gets.chomp
    Player.find_or_create_player(@username)
    self.menu
  end

  def self.menu
    player = Player.find_by(username: @username)
    menu_choice = nil

    until menu_choice == "5"
      self.display_menu_choices
      menu_choice = gets.chomp
      puts
      player = Player.find_by(username: @username)

      case menu_choice
      when "1"
        self.start_a_game(player)
      when "2"
        if player.get_player_scores.empty?
          puts "You haven't played a game!"
        else
          puts "Your high score is: #{player.get_player_scores.max}"
        end
        puts
      when "3"
        if player.get_player_scores.empty?
          puts "You haven't played a game!"
        else
          puts "Your average score is: #{player.get_players_avg_score}"
        end
        puts
      when "4"
        self.get_username
        break
      when "5"
        puts "-----------------------------"
        puts "Thanks for playin! Peace out!"
        puts "-----------------------------"
        puts
      else
        puts "Please select a valid input:"
      end
    end
  end

  def self.display_menu_choices
    puts "Choose an option:"
    puts "1. Play a game"
    puts "2. See your high score"
    puts "3. See your average score"
    puts "4. Change player profile"
    puts "5. Exit game"
    puts
  end

  def self.start_a_game(player)
    game = Game.create
    game.start_game(player)
  end
end
