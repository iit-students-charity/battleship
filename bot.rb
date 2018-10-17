require 'forwardable'

class Bot
  attr_reader :score, :board

  def initialize(board)
    @score = 0
    @board = board
    @printer = Printer.new(@board)
  end

  extend Forwardable
  def_delegator :@printer, :print_enemy, :print
  def_delegator :@board, :set_ship_randomly, :set_ship
  def_delegator :@board, :random_shot, :shot

  def increace_score(value = 100)
    @score += value
  end

  def decreace_score(value = 10)
    @score -= value
  end
end
