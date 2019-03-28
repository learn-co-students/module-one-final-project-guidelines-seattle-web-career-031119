class Round < ActiveRecord::Base
  belongs_to :game
  belongs_to :player

  def get_random_artist(remaining_lyric_i)
    rand_index = remaining_lyric_i.sample
    @remaining_lyric_i.delete(rand_index)
    rand_index
  end

  def randomize_answers(lyric_i)
    answer_options_array =['a. ', 'b. ', 'c. ', 'd. ']
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

  def display_options(lyric_i)
    answer_options_array = self.randomize_answers(lyric_i)
    (0..3).each do |i|
      puts "           ------------------------------------------------"
      puts "              #{Paint[answer_options_array[i], :cyan]}"
      puts "           ------------------------------------------------"
      end
    answer_options_array[4]
  end

  def start_a_round(lyric_i, round_counter)
    @remaining_lyric_i = (1..Lyric.count).collect {|x| x}
    @remaining_lyric_i.delete(lyric_i)

    guess_this_lyric = "\"#{Lyric.find(lyric_i)[:most_lyric]}\""
    guess_this_lyric = Cli.fit_length(guess_this_lyric, ' ')
    system "clear"
    puts
    puts Cli.header
    puts
    puts
    puts "============================== Round #{round_counter} ==============================="
    puts
    puts
    puts "                #{Paint['Pop quiz hotshot! Who sang this line?', :bright]}"
    puts
    puts Paint[guess_this_lyric, :magenta]
    puts
    puts "======================================================================"
    puts

    correct_answer = self.display_options(lyric_i)
    puts
    puts "Choose an artist:"
    puts
    user_answer = gets.chomp
    while !('a'..'d').to_a.include?(user_answer.downcase)
      puts "Please choose between a, b, c, or d"
      user_answer = gets.chomp
      puts
    end

    if user_answer.downcase == correct_answer
      correct_comment = ["You're all that and a bag of chips!", "BOO YA!", "You da bomb!", "Great job home skillet!", "You got it, dude!", "Correctamundo!", "WHOOMP! There it is!"].sample
      correct_comment = Cli.fit_length(correct_comment, ' ')

      puts
      puts Paint[' * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *', :green]
      puts
      puts Paint[correct_comment, :green, :bright]
      puts
      puts Paint[' * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *', :green]
      round = Round.update(self.id, :score => 20)
    else
      incorrect_comment = ["As if!", "Talk to the hand!", "That's right ...NOT!!", "Like, totally not even close.", "Ugh, whatever...", "Check yo self before you wreck yo self!"].sample
      incorrect_comment = Cli.fit_length(incorrect_comment, ' ')
      puts
      puts Paint[' * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *', :red]
      puts
      puts Paint[incorrect_comment, :red, :bright]
      puts
      puts Paint[' * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *', :red]
    end
    sleep(2)
  end

end
