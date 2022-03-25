# frozen_string_literal: true

##
# The board for connect four game
class Board
  attr_reader :board

  def initialize
    @board = Array.new(6) { Array.new(7, nil) }
    @last_inserted = [0, 0]
  end

  def add_token(column, token)
    added = false
    board.length.times do |row|
      next if added || !@board[row][column].nil?

      @board[row][column] = token
      @last_inserted = [row, column]
      added = true
    end
    added
  end

  def four_in_a_row?
    connected_four = false
    board.length.times do |row_index|
      board[0].length.times do |colum_index|
        connected_four = true if check_connected_four?(row_index, colum_index)
      end
    end
    connected_four
  end

  def column_filled?(number)
    filled = true
    board.length.times do |index|
      filled = false if board[index][number].nil?
    end
    filled
  end

  def filled?
    filled = true
    board[0].length.times do |column|
      filled = false unless column_filled?(column)
    end
    filled
  end

  def to_s
    board_string = "Current board: \n"
    board_string += "    0 1 2 3 4 5 6 \n    --------------\n"
    board.reverse.each_with_index do |row, index|
      board_string += "#{index} | "
      row.each do |square|
        board_string += square.nil? ? '  ' : square.symbol.to_s
      end
      board_string += "\n"
    end
    board_string
  end

  private

  def check_connected_four?(row, column)
    # Travel throught all directions from [row, colum] token and check for four in any direction
    four_in_a_row = false
    directions = [[1, 0],   # South
                  [1, 1],   # South-east
                  [0, 1],   # East
                  [-1, 1],  # North-east
                  [-1, 0],  # North
                  [-1, -1], # North-weast
                  [0, -1],  # Weast
                  [1, -1]]  # South-weast

    directions.each do |direction|
      count = 1
      current_cell = [row, column]
      3.times do
        next_cell = [current_cell[0] + direction[0],
                     current_cell[1] + direction[1]]

        break if board[current_cell[0]][current_cell[1]].nil? ||
                 !next_cell[0].between?(0, board.length - 1) ||
                 !next_cell[1].between?(0, board[1].length - 1)

        count += 1 if board[current_cell[0]][current_cell[1]] == board[next_cell[0]][next_cell[1]]
        current_cell = next_cell
      end
      four_in_a_row = true if count == 4
    end
    four_in_a_row
  end
end
