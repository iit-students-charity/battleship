class Ship
  attr_reader :orientation, :length, :cells, :health

  def initialize(x, y, orientation, length)
    @x = x
    @y = y
    @orientation = orientation
    @length = length
    @health = length
    create_cells
  end

  def damage
    if @health > 0
      @health -= 1
    else
      destroy
    end
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
    @cells = []
    @cells << cells_coordinates.each do |pair| 
      cell = Cell.new(pair.first, pair.last)
      cell.ship!(self)
      cell
    end
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

  def destroy
    @cells.map(&:destroyed_ship!)
  end
end
