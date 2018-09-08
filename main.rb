class Cell
  attr_reader :x, :y, :type

  def initialize(x, y, type = :empty)
    @x = x
    @y = y
    @type = type
  end

  def adjoin!
    @type = :adjoined
  end

  def empty!
    @type = :empty
  end

  def ship!
    @type = :ship
  end

  def fired!
    @type = :fired
  end

  def fired_ship!
    @type = :fired_ship
  end

  def adjoined?
    @type == :adjoined
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
  attr_reader :x, :y, :direction, :length

  def initialize(x, y, direction, length)
    @x = x
    @y = y
    @direction = direction
    @length = length
  end

  def coordinates
    if direction == :up
      coordinates << length.times do |number|
        [x, y - number]
      end
    end
    if direction == :right
      coordinates << length.times do |number|
        [x + number, y]
      end
    end
  end
end

class Board
  attr_reader :size_x, :size_y, :ships

  def initialize(size_x = 10, size_y = 10)
    @size_x = size_x
    @size_y = size_y
    set_board
  end

  def set_ship(ship)
    raise IncorrectPlace unless check_ship(ship)
    #@ships << ship
    ship.coordinates.each do |pair|
      @cells.select { |cell| cell.x == pair.first && cell.y == pair.last }.first.ship!
    end
    set_adjoined(ship.coordinates)
  end

  def set_random_ships

  end

  def reset

  end

  def shot(x, y)

  end

  def random_shot

  end

  private

  def check_ship(coordinates)
    coordinates.each do |pair|
      return false if @cells.select { |cell| cell.x  == pair.first && cell.y == pair.last }.first.ship?
      return false if @cells.select { |cell| cell.x  == pair.first && cell.y == pair.last }.first.adjpined?
    end
    return false if coordinates.map(&:first).each { |x| x > 10 || x < 1 }
    return false if coordinates.map(&:second).each { |y| y > 10 || y < 1 }
    true
  end

  def set_board
    size_x.times do |x|
      size_y.times do |y|
        @cells << Cell.new(x + 1, y + 1)
      end
    end
  end

  def set_adjoined(ship)
    ship.coordinates.each do |pair|
      adjoined = adjoined_array(pair)
      adjoined.map(&:adjoin!)
    end
  end

  def adjoined_array(pair)
    (-1..1).each do |i|
      (-1..1).each do |j|
        adj << @cells.select { |cell| cell.x  == pair.first + i && cell.y == pair.last + j && !cell.ship? }.first
      end
    end
    adj
  end
end

