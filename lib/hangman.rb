# frozen_string_literal: true

require 'json'

class Hangman
  def initialize(**kwargs)
    if kwargs[:arg1]
      @dictionary = load_dictionary
      @lives = 10
      @word = generate_word
      @word_hidden = @word.gsub(/[a-z]/, '_ ')
    end
    return unless kwargs[:arg2]

    @lives = kwargs[:arg2]['lives']
    @word = kwargs[:arg2]['word']
    @word_hidden = kwargs[:arg2]['word_hidden']
  end

  def welcome
    puts 'Welcome to Hangman!'
    puts '- New Game (n)'
    file = File.read('save.txt')
    puts '- Continue (c)' unless file == ''
    option = gets.chomp
    if option == 'n'
      play
    elsif option == 'c'
      file = File.read('save.txt')
      if file == ''
        puts '--- No saves found ---'
        exit
      else
        resume = Hangman.load(file)
        resume.play
      end
    end
  end

  def play
    puts "\nsave (-s)"
    puts "\nLives: #{@lives}"
    puts @word_hidden

    while @lives.positive?
      player_guess = gets.chomp
      if player_guess == '-s'
        save
        exit
      end

      if correct?(player_guess)
        puts "\nLives: #{@lives}"
        puts generate_hidden_word(player_guess)
        if win?
          puts "\nYou win!"
          delete_save
          exit
        end
      else
        decrement_lives
        puts "\nLives: #{@lives}"
        puts @word_hidden
      end
    end
    puts "\nThe word was '#{@word}'"
    puts 'Game Over!'
    delete_save
  end

  def self.load(string)
    data = JSON.parse string
    new(arg2: data)
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

  def decrement_lives
    @lives -= 1
  end

  # generates an updated hidden word after the player makes a guess
  def generate_hidden_word(guess)
    split_word = @word.split('')
    split_word_hidden = @word_hidden.split(' ')

    correct_indexes = split_word.each_index.select { |i| split_word[i] == guess }
    correct_indexes.each { |i| split_word_hidden[i] = guess }

    @word_hidden = split_word_hidden.join(' ')
  end

  def correct?(guess)
    @word.include?(guess)
  end

  def win?
    @word == @word_hidden.split(' ').join('')
  end

  def save
    save = JSON.dump({
                       lives: @lives,
                       word: @word,
                       word_hidden: @word_hidden
                     })
    File.open('save.txt', 'w') { |file| file.puts save }
  end

  def delete_save
    File.open('save.txt', 'w') { |file| file.print '' }
  end
end
