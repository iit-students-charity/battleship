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

  def increace_score(value = 100)
    @score += value
  end

  def decreace_score(value = 10)
    @score -= value
  end

  def set_ship_randomly(length)
    begin
      retries ||= 0
      x = rand(0..@board.size_x)
      y = rand(0..@board.size_y)
      direction = [:up, :right].sample
      @board.set_ship(Ship.new(x, y, direction, length))
    rescue IncorrectPlaceException(length)
      (retries += 1) < 100 ? retry : puts("Bot cannot place ship with #{length} cells :(")
    end
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