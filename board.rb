class Board
  attr_reader :size_x, :size_y, :ships, :cells

  def initialize(size_x = 10, size_y = 10)
    @size_x = size_x
    @size_y = size_y
    @cells = []
    @ships = []
    @shots = []
    set_board
  end

  def set_ship(ship)
    raise IncorrectPlaceException unless check_ship(ship.coordinates)
    @ships << ship
    ship.coordinates.each do |pair|
      cell(pair.first, pair.last).ship!
    end
    set_adjoined(ship.coordinates)
  end

  def reset
    @cells = []
    set_board
  end

  def shot(x, y)
    if cell(x, y).ship?
      cell(x, y).damaged_ship!
      return :hit
    end
    if
      cell(x, y).empty? || cell(x, y).adjoined?
      cell(x, y).fired!
      :miss
    else
      :incorrect
    end
  end

  private

  def check_ship(coordinates)
    coordinates.each do |pair|
      return false if cell(pair.first, pair.last).ship?
      return false if cell(pair.first, pair.last).adjoined?
    end
    coordinates.map(&:first).each { |x| return false if x > 10 || x < 1 }
    coordinates.map(&:last).each { |y| return false if y > 10 || y < 1 }
    true
  end

  def cell(x, y)
    @cells.select { |cell| cell.x == x && cell.y == y }.first
  end

  def set_board
    size_x.times do |x|
      size_y.times do |y|
        @cells << Cell.new(x + 1, y + 1)
      end
    end
  end

  def set_adjoined(coordinates)
    coordinates.each do |pair|
      adjoined = adjoined_array(pair)
      adjoined.map(&:adjoin!)
    end
  end

  def adjoined_array(pair)
    adjoined = []
    (-1..1).each do |i|
      (-1..1).each do |j|
        adjoined << @cells.select { |cell| cell.x  == pair.first + i && cell.y == pair.last + j && !cell.ship? }.first
      end
    end
    adjoined.reject(&:nil?)
  end
end