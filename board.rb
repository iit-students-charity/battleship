class Board
  attr_reader :size_x, :size_y, :ships, :cells

  def initialize(size_x = 10, size_y = 10)
    @size_x = size_x
    @size_y = size_y
    @ships = []
    @shots = []
    set_board
  end

  def set_ship(ship)
    raise IncorrectPlaceException unless check_ship(ship.cells)
    @ships << ship
    ship.cells.each do |cell|
      index = @cells.index(cell(cell.x, cell.y))
      @cells[index] = cell
    end
    set_adjoined(ship.cells)
  end

  def shot(x, y)
    shot = Shot.new(cell(x, y))
    shot.perform
    shot
  end

  private

  def check_ship(cells)
    cells.each { |cell| return false if cell(cell.x, cell.y)&.ship? || cell(cell.x, cell.y)&.adjoined? }
    cells.map(&:x).each { |x| return false if x > size_x || x < 1 }
    cells.map(&:y).each { |y| return false if y > size_y || y < 1 }
    true
  end

  def cell(x, y)
    @cells.select { |cell| cell.x == x && cell.y == y }.first
  end

  def set_board
  	@cells = []
    size_x.times do |x|
      size_y.times do |y|
        @cells << Cell.new(x + 1, y + 1)
      end
    end
  end

  def set_adjoined(cells)
    cells.each do |cell|
      cell.adjoined_coordinates.each do |pair| 
      	cell(pair.first, pair.last)&.adjoin! unless cell(pair.first, pair.last)&.ship?
      end
    end
  end
end
