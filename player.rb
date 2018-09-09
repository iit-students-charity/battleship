require 'forwardable'

class Player
  attr_reader :score, :board

  def initialize(board)
    @score = 0
    @board = board
    @printer = Printer.new(@board)
  end

  extend Forwardable
  def_delegator :@board, :shot
  def_delegator :@printer, :print_ours, :print

  def increace_score(value = 100)
    @score += value
  end

  def decreace_score(value = 10)
    @score -= value
  end
end