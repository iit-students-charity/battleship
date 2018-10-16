class Ship
  attr_reader :orientation, :length, :cells, :x, :y

  def initialize(x, y, orientation, length)
    @x = x
    @y = y
    @orientation = orientation
    @length = length
    create_cells
  end

  def damage(x, y)
    cell(x, y).damaged_ship!
    destroy if health <= 0
  end

  def destroyed?
    health <= 0
  end

  def health
    @cells.reduce { |cell| cell.damaged_ship? }.count
  end

  def up?
    @orientation == :up
  end

  def right?
    @orientation == :right
  end

  private

  def cells_coordinates
    up? ? up_coordinates : right_coordinates
  end
  
  def create_cells
    @cells = []
    cells_coordinates.each do |pair|
      cell = Cell.new(pair.first, pair.last)
      cell.ship!(self)
      @cells << cell
    end
  end

  def up_coordinates
    coordinates = []
    @length.times do |number|
      coordinates << [@x, @y - number]
    end
    coordinates
  end

  def right_coordinates
    coordinates = []
    @length.times do |number|
      coordinates << [@x + number, @y]
    end
    coordinates
  end

  def destroy
    @cells.map(&:destroyed_ship!)
  end
end
