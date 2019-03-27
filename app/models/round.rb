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
    (0..3).each {|i| puts answer_options_array[i]}
    answer_options_array[4]
  end

  def start_a_round(lyric_i, current_game, player)
    @remaining_lyric_i = (1..Lyric.count).collect {|x| x}
    @remaining_lyric_i.delete(lyric_i)

    guess_this_lyric = Lyric.find(lyric_i)
    puts "------------------------------"
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
      round = Round.update(self.id, :score => 5)
    else
      puts "Not quite dude!"
    end
    puts
  end

end
