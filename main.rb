require 'pry'

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

class Board
  attr_reader :size_x, :size_y, :ships, :cells

  def initialize(size_x = 10, size_y = 10)
    @size_x = size_x
    @size_y = size_y
    @cells = []
    set_board
  end

  def set_ship(ship)
    raise IncorrectPlace unless check_ship(ship.coordinates)
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
      return false if @cells.select { |cell| cell.x  == pair.first && cell.y == pair.last }.first.adjoined?
    end
    coordinates.map(&:first).each { |x| return false if x > 10 || x < 1 }
    coordinates.map(&:last).each { |y| return false if y > 10 || y < 1 }
    true
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

class BoardPrinter
  attr_reader :board

  def initialize(board)
    @board = board
  end

  def print_ours
    (board.size_x + 3).times { |number| number > 2 ? print(number - 2, ' ') : print(' ') }
    puts
    (board.size_x * 2 + 3).times { |number| number > 1 ? print('_') : print(' ') }
    puts
    board.size_y.times do |y|
      print(' ') if y < 9
      print(y + 1, '|')
      board.size_x.times do |x|
        cell = board.cells.select { |cell| cell.x == x + 1 && cell.y == y + 1 }.first
        print('_') if cell.empty?
        print('@') if cell.ship?
        print('߸') if cell.fired?
        print('_') if cell.adjoined?
        print('🔥') if cell.fired_ship?
        print('|')
      end
      puts
    end
  end

  def print_enemy
    (board.size_x + 3).times { |number| number > 2 ? print(number - 2, ' ') : print(' ') }
    puts
    (board.size_x * 2 + 3).times { |number| number > 1 ? print('_') : print(' ') }
    puts
    board.size_y.times do |y|
      print(' ') if y < 9
      print(y + 1, '|')
      board.size_x.times do |x|
        cell = board.cells.select { |cell| cell.x == x + 1 && cell.y == y + 1 }.first
        print('_') if cell.empty?
        print('_') if cell.ship?
        print('߸') if cell.fired?
        print('_') if cell.adjoined?
        print('🔥') if cell.fired_ship?
        print('|')
      end
      puts
    end
  end
end

SHIPS = [ Ship.new(6, 2, :right, 4),
          Ship.new(2, 5, :right, 3),
          Ship.new(7, 5, :right, 3),
          Ship.new(2, 2, :right, 2),
          Ship.new(6, 9, :up, 2),
          Ship.new(9, 9, :up, 2),
          Ship.new(1, 7, :right, 1),
          Ship.new(1, 10, :right, 1),
          Ship.new(3, 8, :right, 1),
          Ship.new(4, 10, :right, 1) ]

board = Board.new
SHIPS.each { |ship| board.set_ship(ship) }
BoardPrinter.new(board).print_enemy














