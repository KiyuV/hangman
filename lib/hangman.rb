require 'json'

class Hangman
  def initialize
    @dictionary = load_dictionary
    @lives = 10
    @word = generate_word
    @word_hidden = @word.gsub(/[a-z]/, '_ ')
  end

  def play
    puts 'Welcome to Hangman!'
    puts "\nLives: #{@lives}"
    puts @word_hidden
    
    while @lives> 0 do
      player_guess = gets.chomp
      if correct?(player_guess)
        puts "\nLives: #{@lives}"
        puts generate_hidden_word(player_guess)
        if win?
          puts "\nYou win!"
          exit
        end
      else
        decrement_guess
        puts "\nLives: #{@lives}"
        puts @word_hidden
      end
    end
    puts "\nThe word was '#{@word}'"
    puts 'Game Over!'
  end

  private

  def load_dictionary
    dictionary = []
    file = File.readlines('google-10000-english-no-swears.txt')
    file.each do |word|
      word = word.chomp
      dictionary.push(word) if word.length >= 5 && word.length <= 12
    end
    dictionary
  end

  def generate_word
    @dictionary.sample
  end

  def decrement_guess
    @lives -= 1
  end
  # generates 
  def generate_hidden_word(guess)
    split_word = @word.split('')
    split_word_hidden = @word_hidden.split(' ')

    correct_indexes = split_word.each_index.select { |i| split_word[i] == guess}
    correct_indexes.each { |i| split_word_hidden[i] = guess}

    @word_hidden = split_word_hidden.join(' ')
  end

  def correct?(guess)
    @word.include?(guess)
  end

  def win?
    @word == @word_hidden.split(' ').join('')
  end
end