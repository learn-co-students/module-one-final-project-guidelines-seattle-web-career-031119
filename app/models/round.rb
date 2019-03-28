class Round < ActiveRecord::Base
  belongs_to :game
  belongs_to :player

  def get_random_artist(remaining_lyric_i)
    rand_index = remaining_lyric_i.sample
    @remaining_lyric_i.delete(rand_index)
    rand_index
  end

  def randomize_answers(lyric_i)
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

  def display_options(lyric_i)
    answer_options_array = self.randomize_answers(lyric_i)
    (0..3).each do |i|
      puts "           ------------------------------------------------"
      puts "              #{Paint[answer_options_array[i], :blue]}"
      puts "           ------------------------------------------------"
      end
    answer_options_array[4]
  end

  def start_a_round(lyric_i, current_game, player, round_counter)
    @remaining_lyric_i = (1..Lyric.count).collect {|x| x}
    @remaining_lyric_i.delete(lyric_i)

    guess_this_lyric = "\"#{Lyric.find(lyric_i)[:most_lyric]}\""
    until guess_this_lyric.length >= 70
      guess_this_lyric.prepend(' ')
      guess_this_lyric << ' '
    end
    puts
    puts Paint%["============================ I %{heart} THE 90s ============================", :cyan, :bright, heart: ["<3", :magenta]]
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
      correct_comment = ["You're all that and a bag of chips!", "BOO YA!", "You da bomb!", "Great job home skillet!", "You got it, dude!", "Correctamundo!"].sample
      until correct_comment.length >= 70
        correct_comment.prepend(' ')
        correct_comment << ' '
      end
      puts
      puts Paint[' * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *', :green]
      puts
      puts Paint[correct_comment, :green, :bright]
      puts
      puts Paint[' * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *', :green]
      round = Round.update(self.id, :score => 5)
    else
      incorrect_comment = ["As if!", "Talk to the hand!", "That's right ...NOT!!", "Like, totally not even close.", "Ugh, whatever..."].sample
      until incorrect_comment.length >= 70
        incorrect_comment.prepend(' ')
        incorrect_comment << ' '
      end
      puts
      puts Paint[' * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *', :red]
      puts
      puts Paint[incorrect_comment, :red, :bright]
      puts
      puts Paint[' * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *', :red]
    end
    sleep(2)
    system "clear"
  end

end
