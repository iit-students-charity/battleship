class Ship
  attr_reader :x, :y, :direction, :length

  def initialize(x, y, direction, length)
    @x = x
    @y = y
    @direction = direction
    @length = length
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
end
