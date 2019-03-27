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
    @username = gets.chomp
    Player.find_or_create_player(@username)
  end

  def self.display_menu_choices
    puts "Choose an option:"
    puts "1. Play a game"
    puts "2. See your high score"
    puts "3. See your average score"
    puts "4. Exit game"
    puts
  end

  def self.menu
    self.display_menu_choices
    menu_choice = gets.chomp
    puts

    while menu_choice != "4"
      if menu_choice == "1"
        self.start_a_game
      elsif menu_choice == '2'
        player = Player.find_by(username: @username)
        puts "Your high score is: #{self.get_players_high_score(player)}"
        puts
      elsif menu_choice == "3"
        player = Player.find_by(username: @username)
        puts "Your average score is: #{self.get_players_avg_score(player)}"
        puts
      else
        puts "Please select a valid input:"
      end

      self.display_menu_choices
      menu_choice = gets.chomp
      puts
    end
  end

  def self.get_players_high_score(player)
    games = player.games.uniq
    games.collect do |game|
      self.get_game_score(game)
    end.max
  end

  def self.get_game_score(game)
    scores = Round.where(game_id: game.id).collect {|a_round| a_round[:score]}
    scores.inject(0) {|score, sum| sum + score}
  end

  def self.get_players_avg_score(player)
    scores = Round.where(player_id: player.id).collect {|a_round| a_round[:score]}
    if scores.empty?
      "You have no scores!"
    else
      (scores.inject(0) {|score, sum| sum + score}.to_f / player.rounds.collect {|round| round[:game_id]}.uniq.count).round(2)
    end
  end

  def self.start_a_game
    current_game = Game.create
    round_counter = 1
    songs_already_chosen =[]

    while round_counter <= 4
      lyric_i = rand(1..Lyric.count)
      while songs_already_chosen.include?(lyric_i)
        lyric_i = rand(1..Lyric.count)
      end

      songs_already_chosen << lyric_i
      self.a_single_round(lyric_i, current_game)
      round_counter +=1
    end

    scores = Round.where(game_id: current_game.id).collect {|a_round| a_round[:score]}
    puts "-------------------------------"
    puts
    puts "Nice game dude!"
    puts "Your total is: #{scores.inject(0) {|score, sum| sum + score}}"
    puts
    puts "-------------------------------"
  end

  def self.get_random_artist(remaining_lyric_i)
    rand_index = remaining_lyric_i.sample
    @remaining_lyric_i.delete(rand_index)
    rand_index
  end

  def self.a_single_round(lyric_i, current_game)
    player = Player.find_by(username: @username)
    round = Round.create(game_id: current_game.id, player_id: player.id, score: 0)
    @remaining_lyric_i = (1..Lyric.count).collect {|x| x}
    @remaining_lyric_i.delete(lyric_i)

    guess_this_lyric = Lyric.find(lyric_i)
    puts "Which artist wrote this lyric?"
    puts "\"#{guess_this_lyric[:most_lyric]}\""
    puts

    correct_answer = self.display_options(lyric_i)
    puts
    puts "Choose an artist:"
    user_answer = gets.chomp

    while !('a'..'d').to_a.include?(user_answer.downcase)
      puts "Please choose between a, b, c, or d"
      user_answer = gets.chomp
    end

    if user_answer.downcase == correct_answer
      puts "You got it!"
      round = Round.update(round.id, :score => 5)
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
