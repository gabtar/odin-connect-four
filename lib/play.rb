# frozen_string_literal: true

require_relative './game/game'
require_relative './game/board'
require_relative './game/player'
require_relative './game/token'

player_one = Player.new('Player 1', Token.new('⚫'))
player_two = Player.new('Player 2', Token.new('⚪'))
board = Board.new
game = Game.new(player_one, player_two, board)
game.play_game
