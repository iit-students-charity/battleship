require 'forwardable'

class Player
  attr_reader :score, :board, :name

  def initialize(board, name = nil)
    @score = 0
    @name = name
    @board = board
    @printer = Printer.new(@board)
  end

  extend Forwardable
  def_delegator :@board, :random_shot, :random_shot_on
  def_delegator :@board, :shot, :shot_on
  def_delegator :@board, :set_ship
  def_delegator :@board, :set_ship_randomly
  def_delegator :@printer, :print_open, :print
  def_delegator :@printer, :print_hidden

  def increase_score(value = 100)
    @score += value
  end

  def decrease_score(value = 10)
    @score -= value
    @score = @score < 0 ? 0 : @score
  end

  def defeated?
    !@board.cells.map(&:ship?).include?(true)
  end
end
