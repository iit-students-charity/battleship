class Ship
  attr_reader :x, :y, :direction, :length, :cells

  def initialize(x, y, direction, length)
    @x = x
    @y = y
    @direction = direction
    @length = length
    create_cells
  end

  def coordinates
    coordinates = []
    if direction == :up
      length.times do |number|
        coordinates << [x, y - number]
      end
    end
    if direction == :right
      length.times do |number|
        coordinates << [x + number, y]
      end
    end
    coordinates
  end

private:
  
  def create_cells
    @cells = coordinates.map { |pair| Cell.new(pair.first, pair.last, :ship) }
  end

end
