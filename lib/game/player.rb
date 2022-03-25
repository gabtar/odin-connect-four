# frozen_string_literal: true

##
# Represents a Player of the game
# Could have been a simple Struct
class Player
  attr_reader :name, :token

  def initialize(name, token)
    @name = name
    @token = token
  end
end
