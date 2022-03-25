# frozen_string_literal: true

require_relative '../lib/game/board'
require_relative '../lib/game/token'

require 'rspec'

RSpec.describe Board do
  subject(:board) { described_class.new }
  let(:token) { Token.new('⚫') }
  let(:token_opponent) { Token.new('⚪') }

  describe '#add_token' do
    context 'when add a new token to a column' do
      it 'adds the specified token to the given column' do
        board.add_token(0, token)
        expect(board.board[0][0]).to eql(token)
      end
    end

    context 'when the column already has a token ' do
      it 'adds the token to the next row' do
        board.add_token(0, token)
        board.add_token(0, token)
        expect(board.board[1][0]).to eql(token)
      end
    end

    context 'when the column is complete' do
      it 'dont add the token' do
        # Adds maximun tokens + 1(6 + 1)
        # Fill first colum
        6.times { board.add_token(0, token) }
        # Add another to the first colum
        expect(board.add_token(0, token)).to be_falsy
      end
    end
  end

  describe '#four_in_a_row?' do
    context 'when there are four in a row' do
      it 'returns true' do
        4.times { |time| board.add_token(time, token) }
        expect(board.four_in_a_row?).to be_truthy
      end
    end

    context 'when there are not four in a row' do
      it 'returns false' do
        3.times { |time| board.add_token(time, token) }
        expect(board.four_in_a_row?).to be_falsy
      end
    end

    context 'when there are four in a column' do
      it 'returns true' do
        4.times { board.add_token(0, token) }
        expect(board.four_in_a_row?).to be_truthy
      end
    end

    context 'when there are four in a diagonal' do
      it 'returns true' do
        board.add_token(1, token)
        2.times { board.add_token(2, token) }
        3.times { board.add_token(3, token) }
        4.times { |column| board.add_token(column, token_opponent) }
        expect(board.four_in_a_row?).to be_truthy
      end
    end
  end

  describe '#column_filled?' do
    context 'when a the first column is complete' do
      it 'returns true' do
        6.times { board.add_token(0, token) }
        expect(board.column_filled?(0)).to be_truthy
      end
    end

    context 'when the first column is not complete' do
      it 'returns false' do
        2.times { board.add_token(0, token) }
        expect(board.column_filled?(0)).to be_falsy
      end
    end
  end

  describe '#board_filled?' do
    context 'when the board is complete' do
      it 'returns true' do
        7.times { |column| 6.times { board.add_token(column, token) } }
        expect(board.filled?).to be_truthy
      end
    end

    context 'when the board is not complete' do
      it 'returns false' do
        expect(board.filled?).to be_falsy
      end
    end
  end
end
