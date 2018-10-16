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

  def increace_score(value = 100)
    @score += value
  end

  def decreace_score(value = 10)
    @score -= value
  end

  def shot
    coords = shot_coords
    current_shot = board.shot(*coords)
    shot if current_shot.incorrect?
    @last_shot = current_shot if current_shot.hit?
    @last_shot = nil if current_shot.destroy?
  end

  private

  def shot_coords
    if @last_shot
      @last_shot.cell.surrounding_coordinates.sample
    else
      [rand(0..@board.size_x), rand(0..@board.size_y)]
    end
  end
end
