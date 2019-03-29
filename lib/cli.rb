require_relative '../config/environment.rb'

class Cli
  attr_accessor :username

  @game_width = 70

  def self.welcome_message
    puts
    self.header
    puts
    puts
    self.line("#{Paint['/', :yellow]}")
    self.line("#{Paint['\\', :cyan]}")
    self.line("#{Paint['/', :magenta]}")
    puts
    puts Paint[self.fit_length("How 90's are you?", ' '), :cyan, :bright]
    puts
    puts Paint[self.fit_length("Test your 90's music knowledge", ' '), :magenta, :bright]
    puts
    puts self.fit_length("There are 5 rounds", ' ')
    puts self.fit_length("Each round is worth 20 points", ' ')
    puts self.fit_length("Get 100 points and be the dopest homie on da block!", ' ')
    puts self.fit_length("Let's get jiggy with it!", ' ')
    puts
    self.line("#{Paint['\\', :magenta]}")
    self.line("#{Paint['/', :yellow]}")
    self.line("#{Paint['\\', :cyan]}")
    puts
    self.get_username
  end

  def self.get_username
    puts "Ready to play?"
    puts
    puts Paint["Enter your username:", :inverse]
    puts
    @username = gets.chomp
    system "clear"
    Player.find_or_create_player(@username)
    self.menu
  end

  def self.menu
    menu_choice = nil

    until menu_choice == "6"
      self.display_menu_choices
      menu_choice = gets.chomp
      puts
      player = Player.find_by(username: @username)

      case menu_choice
      when "1"
        system "clear"
        self.start_a_game(player)
      when "2"
        system "clear"
        puts
        self.header
        puts
        if player.get_player_scores.empty?
          puts "You haven't played a game yet! Duh!"
        else
          puts "Your high score is: #{player.get_player_scores.max}"
        end
        puts
      when "3"
        system "clear"
        puts
        self.header
        puts
        if player.get_player_scores.empty?
          puts "You haven't played a game yet! Duh!"
        else
          puts "Your average score is: #{player.get_players_avg_score}"
        end
        puts
      when "4"
        system "clear"
        puts
        self.header
        puts
        puts
        self.display_leaderboard
        puts
      when "5"
        system "clear"
        puts
        self.header
        puts
        self.get_username
        break
      when "6"
        system "clear"
        puts
        self.header
        puts
        puts
        self.line('*')
        puts
        puts
        puts self.fit_length("Thanks for playin!", ' ')
        puts
        puts self.fit_length("PEACE OUT!", ' ')
        puts
        puts
        self.line('*')
        puts
      else
        system "clear"
        puts
        self.header
        puts
        puts Paint["Please select a valid input:", :yellow]
        puts
      end
    end
  end

  def self.display_menu_choices
    self.line('=')
    puts
    puts Paint["Choose an option:", :inverse]
    puts
    puts " 1. Play a game"
    puts
    puts " 2. See your high score"
    puts
    puts " 3. See your average score"
    puts
    puts " 4. View Leaderboard (Highest Average Scores)"
    puts
    puts " 5. Change player"
    puts
    puts " 6. Exit game"
    puts
    self.line('=')
    puts
  end

  def self.start_a_game(player)
    game = Game.create
    game.start_game(player)
  end

  def self.fit_length(string, character)
    until string.length >= @game_width
      string.prepend(character)
      string << character
    end
    string
  end

  def self.display_leaderboard
    leaderarray = Player.leaderboard
    table = Terminal::Table.new:title => "Leaderboard (Best Average)", :headings => ['Player', 'Score'], :rows => leaderarray, :style => {:width => 40}
    table.style = {:width => 40, :padding_left => 3, :border_x => "=", :border_i => "x"}
    puts table
    puts
  end

  def self.header
    puts Paint%["==================== %{title} ====================", :cyan, :bright, title: ["NOW THAT'S WHAT I CALL 90's!", :magenta]]
  end

  def self.line(character)
    puts character * @game_width
  end
end
