# frozen_string_literal: true

##
# A token/piece for the board
class Token
  attr_reader :symbol

  def initialize(symbol)
    @symbol = symbol
  end
end
