class Cell
  attr_accessor :type
  attr_reader :x, :y

  def initialize(x, y, type = :empty)
    @x = x
    @y = y
    @type = type
  end

  def empty?
    @type == :empty
  end

  def ship?
    @type == :ship
  end

  def fired?
    @type == :fired
  end

  def fired_ship?
    @type == :fired_ship
  end
end

class Ship
  def initialize()
end

class Board
  attr_reader :size_x, :size_y

  def initialize(size_x = 10, size_y = 10)
    @size_x = size_x
    @size_y = size_y
    set_board
  end

  def set_ships(ships)

  end

  def set_random_ships()

  end

  def reset

  end

  def shot(x, y)

  end

  def random_shot

  end

  private

  def set_board

  end


end