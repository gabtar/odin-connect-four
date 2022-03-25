# frozen_string_literal: true

##
# Represents a game of four in a row
# between 2 human players
class Game
  def initialize(player_one, player_two, board)
    @player_one = player_one
    @player_two = player_two
    @board = board
    @turn = @player_one
  end

  def input_column
    loop do
      print "#{@turn.name}, enter a column: "
      column_number = gets.chomp
      return column_number.to_i if column_number.match?('^[0-6]$') && !@board.column_filled?(column_number.to_i)

      puts 'Invalid column! Try again'
    end
  end

  def switch_turn
    @turn = @turn == @player_one ? @player_two : @player_one
  end

  def play_turn
    puts @board
    column = input_column
    @board.add_token(column, @turn.token)
  end

  def display_winner
    puts @board
    if @board.four_in_a_row?
      puts "#{@turn.name} wins!!!"
    else
      puts 'Tied game!!!!'
    end
  end

  def play_game
    welcome_to_game
    loop do
      play_turn
      break if @board.four_in_a_row? || @board.filled?

      switch_turn
    end
    display_winner
  end

  def welcome_to_game
    puts <<~WELCOME
      -------------------------------------------------------------------------
      Welcome to Connect Four!!!
      -------------------------------------------------------------------------
      A two-player connection board game, in which the players choose a color
      and then take turns dropping colored tokens into a seven-column, six-row
      vertically suspended grid. The pieces fall straight down, occupying the
      lowest available space within the column. The objective of the game is to
      be the first to form a horizontal, vertical, or diagonal line of four of
      one's own tokens.
      -------------------------------------------------------------------------
    WELCOME
  end
end
