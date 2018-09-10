class Ship
  attr_reader :x, :y, :orientation, :length, :cells

  def initialize(x, y, orientation, length)
    @x = x
    @y = y
    @orientation = orientation
    @length = length
    create_cells
  end

  def up?
    @orientation == :up
  end

  def right?
    @orientation == :right
  end

private:

  def cells_coordinates
    coordinates = up? ? up_coordinates : right_coordinates
  end
  
  def create_cells
    @cells = cells_coordinates.map { |pair| Cell.new(pair.first, pair.last, :ship) }
  end

  def up_coordinates
    coordinates = []
    @length.times do |number|
      coordinates << [@x, @y - number]
    end
  end

  def right_coordinates
    coordinates = []
    @length.times do |number|
      coordinates << [@x + number, y]
    end
  end
end
