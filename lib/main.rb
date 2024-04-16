# frozen_string_literal: true

require './lib/hangman'

def main
  game = Hangman.new(arg1: '')
  game.welcome
end

main
