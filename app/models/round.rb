class Round < ActiveRecord::Base
  belongs_to :game
  belongs_to :player

  #to understand rounds, start with method 'start_a_round' and work up

  def get_random_artist
    #gets an index for an artist that hasn't been chosen yet
    rand_index = @remaining_lyric_i.sample
    @remaining_lyric_i.delete(rand_index)
    rand_index
  end

  def randomize_answers
    #this method randomizes the order of the 4 potential answers
    #for example, it would be pretty boring if the correct answer was always a!
    #answer_options_array will be the return array with the correctly formatted strings
    answer_options_array =['a. ', 'b. ', 'c. ', 'd. ']
    #answer_options_remaining is an array of indices that refer to the the positions in answer_options_array
    answer_options_remaining = [0, 1, 2, 3]

    #get three random artist names first
    while answer_options_remaining.count > 1
      #choose random index from answer_options_remaining
      this_index = answer_options_remaining.sample
      #push string of a random artist name to the chosen index
      answer_options_array[this_index] << "#{Lyric.find(self.get_random_artist)[:artist_name]}"
      #delete that index from answer_options_remaining
      answer_options_remaining.delete(this_index)
    end

    #once there are three random artists assigned to random positions in answer_options_array,
    #assign the correct answer to the remining position
    answer_options_array[answer_options_remaining[0]] << "#{Lyric.find(@lyric_i)[:artist_name]}"
    #finally, push the letter for the correct answer to return array as a fifth element
    #this is not displayed, but used to check if the user gets the question right
    answer_options_array << answer_options_array[answer_options_remaining[0]][0]
    answer_options_array
  end

  def display_options
    answer_options_array = self.randomize_answers
    (0..3).each do |i|
      puts "           ------------------------------------------------"
      puts "              #{Paint[answer_options_array[i], :cyan]}"
      puts "           ------------------------------------------------"
      end
    #method returns the 5th element of answer_options_array, which was added as the last step in randomize_answers
    answer_options_array[4]
  end

  def start_a_round(lyric_i, round_counter)
    #a round is started here
    #remaining_lyric_i keeps track of all the lyric id's that haven't yet been used in this round
    #lyric_i is the index for the correct answer
    #first step is to remove lyric_id from remaining_lyric_i
    @lyric_i = lyric_i
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

    correct_answer = self.display_options

    puts
    puts Paint["Choose an artist:", :inverse]
    puts

    user_answer = gets.chomp
    #user must input a, b, c, or d
    while !('a'..'d').to_a.include?(user_answer.downcase)
      puts "Please choose between a, b, c, or d"
      user_answer = gets.chomp
      puts
    end

    if user_answer.downcase == correct_answer
      correct_comment = ["You're all that and a bag of chips!", "BOO YA!", "You da bomb!", "Great job home skillet!", "You got it, dude!", "Correctamundo!", "WHOOMP! There it is!"].sample
      correct_comment = Cli.fit_length(correct_comment + ' +20 pts', ' ')

      puts
      puts Paint[' * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *', :green]
      puts
      puts Paint[correct_comment, :green, :bright]
      puts
      puts Paint[' * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *', :green]
      round = Round.update(self.id, :score => 20)
    else
      incorrect_comment = ["As if!", "Talk to the hand!", "That's right ...NOT!!", "Like, totally not even close.", "Ugh, whatever...", "Check yo self before you wreck yo self!"].sample
      incorrect_comment = Cli.fit_length(incorrect_comment + ' +0 pts', ' ')
      puts
      puts Paint[' * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *', :red]
      puts
      puts Paint[incorrect_comment, :red, :bright]
      puts
      puts Paint[' * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *', :red]
    end
    sleep(3)
  end
end
