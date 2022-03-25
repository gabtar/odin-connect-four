# frozen_string_literal: true

require_relative '../lib/game/game'
require_relative '../lib/game/board'
require_relative '../lib/game/player'
require_relative '../lib/game/token'

# NOTES FOR TESTING:
# Here is a summary of what should be tested
# 1. Command Method -> Test the change in the observable state
# 2. Query Method -> Test the return value
# 3. Method with Outgoing Command -> Test that a message is sent
# 4. Looping Script Method -> Test the behavior of the method

RSpec.describe Game do
  let(:player_one) { Player.new('Player 1', Token.new('⚪')) }
  let(:player_two) { Player.new('Player 2', Token.new('⚫')) }
  let(:board) { Board.new }

  subject(:game) { described_class.new(player_one, player_two, board) }

  describe '#input_column' do
    before do
      message = "#{game.instance_variable_get(:@turn).name}, enter a column: "
      allow(game).to receive(:print).with(message)
    end

    context 'when inputs a valid column' do
      before do
        valid_input = '5'
        allow(game).to receive(:gets).and_return(valid_input)
      end

      it 'returns the column number' do
        message = 'Invalid column! Try again'
        expect(game).not_to receive(:puts).with(message)
        expect(game.input_column).to eql(5)
      end
    end

    context 'when inputs an incorrect column and then a valid column' do
      before do
        invalid_input = '8'
        valid_input = '5'
        allow(game).to receive(:gets).and_return(invalid_input, valid_input)
      end

      it 'loops once displaying an error message until input a valid column' do
        message = 'Invalid column! Try again'
        expect(game).to receive(:puts).with(message).once
        game.input_column
      end
    end

    context 'when inputs two incorrect column and then a valid column' do
      before do
        invalid_input = '8'
        invalid_input_two = 'ccc'
        valid_input = '5'
        allow(game).to receive(:gets).and_return(invalid_input, invalid_input_two, valid_input)
      end

      it 'loops twice displaying an error message until input a valid column' do
        message = 'Invalid column! Try again'
        expect(game).to receive(:puts).with(message).twice
        game.input_column
      end
    end

    context 'when input a valid column but its complete and then a valid column' do
      before do
        6.times { board.add_token(0, player_one.token) }
        complete_column = '0'
        valid_input = '5'
        allow(game).to receive(:gets).and_return(complete_column, valid_input)
      end

      it 'loops once until an incomplete column is input' do
        message = 'Invalid column! Try again'
        expect(game).to receive(:puts).with(message).once
        game.input_column
      end
    end
  end

  describe '#switch_turn' do
    context 'when its player 1 turn' do
      it 'returns player 2' do
        game.switch_turn
        turn = game.instance_variable_get(:@turn)
        expect(turn).to be(player_two)
      end
    end

    context 'when its player 2 turn' do
      it 'returns player 1' do
        game.switch_turn
        game.switch_turn
        turn = game.instance_variable_get(:@turn)
        expect(turn).to be(player_one)
      end
    end
  end

  describe '#display_turn' do
    before do
      valid_input = '3'
      allow(game).to receive(:gets).and_return(valid_input)
    end

    context 'when is player 1 turn' do
      it 'display board and calls input column with message for player 1' do
        message = "#{player_one.name}, enter a column: "
        expect(game).to receive(:puts).with(board).once
        expect(game).to receive(:print).with(message).once
        expect { game.play_turn }.to change { board.board[0][3] }.from(nil).to(player_one.token)
      end
    end

    context 'when is player 2 turn' do
      it 'display board and calls input column with message for player 2' do
        game.switch_turn
        message = "#{player_two.name}, enter a column: "
        expect(game).to receive(:puts).with(board).once
        expect(game).to receive(:print).with(message).once
        expect { game.play_turn }.to change { board.board[0][3] }.from(nil).to(player_two.token)
      end
    end
  end

  describe '#display_winner' do
    context 'when player 1 connects four tokens' do
      before do
        4.times { board.add_token(0, player_one.token) }
      end

      it 'returns a message with the winner' do
        message = 'Player 1 wins!!!'
        expect(game).to receive(:puts).with(message).once
        expect(game).to receive(:puts).with(board).once
        game.display_winner
      end
    end

    context 'when player 2 connects four tokens' do
      before do
        4.times { board.add_token(0, player_two.token) }
        game.switch_turn
      end

      it 'returns a message with the winner' do
        message = 'Player 2 wins!!!'
        expect(game).to receive(:puts).with(message).once
        expect(game).to receive(:puts).with(board).once
        game.display_winner
      end
    end

    context 'when neither player connects four' do
      it 'returns a message saying its a tie game' do
        message = 'Tied game!!!!'
        expect(game).to receive(:puts).with(message).once
        expect(game).to receive(:puts).with(board).once
        game.display_winner
      end
    end
  end

  describe '#play_game' do
    before do
      valid_input = '6'
      allow(game).to receive(:gets).and_return(valid_input)
    end

    context 'when player 1 makes four in a row' do
      it 'exits the loop and then displays the winner' do
        3.times { board.add_token(6, player_one.token) }
        input_message = "#{game.instance_variable_get(:@turn).name}, enter a column: "
        expect(game).to receive(:print).with(input_message).once
        expect(game).to receive(:puts).with(board).once
        expect(game).to receive(:welcome_to_game).once
        expect(game).to receive(:display_winner).once
        game.play_game
      end
    end

    context 'when player 2 makes four in a row' do
      it 'exits the loop and then displays the winner' do
        game.switch_turn
        3.times { board.add_token(6, player_two.token) }
        input_message = "#{game.instance_variable_get(:@turn).name}, enter a column: "
        expect(game).to receive(:print).with(input_message).once
        expect(game).to receive(:puts).with(board).once
        expect(game).to receive(:welcome_to_game).once
        expect(game).to receive(:display_winner).once
        game.play_game
      end
    end

    context 'when no player has connected four, and the next move completes the board' do
      before do
        # Fill the board with a fake tie case
        player = player_one
        7.times do |column|
          3.times { board.add_token(column, player.token) }
          player = player == player_one ? player_two : player_one
          3.times { board.add_token(column, player.token) } unless column == 6
          2.times { board.add_token(column, player.token) } if column == 6
        end
        input_message = "#{player_one.name}, enter a column: "
        allow(game).to receive(:print).with(input_message).once
      end

      it 'exits the loop and displays the game is a tie' do
        expect(game).to receive(:puts).with(board).once
        expect(game).to receive(:welcome_to_game).once
        expect(game).to receive(:display_winner).once
        game.play_game
      end
    end
  end
end
