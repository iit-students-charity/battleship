require 'forwardable'

class Bot
  attr_reader :score, :board

  def initialize(board)
    @score = 0
    @board = board
    @printer = Printer.new(@board)
  end

  extend Forwardable
  def_delegator :@board, :random_shot, :shot_on
  def_delegator :@board, :set_ship
  def_delegator :@board, :set_ship_randomly
  def_delegator :@printer, :print_open, :print
  def_delegator :@printer, :print_hidden

  def increace_score(value = 100)
    @score += value
  end

  def decreace_score(value = 10)
    @score -= value
  end
end
