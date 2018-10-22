class Board
  attr_reader :size_x, :size_y, :ships, :cells, :shots

  def initialize(size_x = 10, size_y = 10)
    @size_x = size_x
    @size_y = size_y
    @ships = []
    @shots = []
    reset
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

  def set_ship_randomly(length)
    success = false
    retries.times do
      ship = random_ship(length)
      if check_ship(ship.cells)
        set_ship(ship)
        success = true
        break
      end
    end
    raise IncorrectPlaceException unless success
  end

  def shot(x, y)
    shot = Shot.new(cell(x, y))
    shot.perform
    @shots << shot
    shot
  end

  def random_shot
    coordinates = random_shot_coordinates
    shot = shot(*coordinates)
    shot = random_shot if shot.incorrect?
    shot
  end

  def reset
    @cells = []
    @size_x.times do |x|
      @size_y.times do |y|
        @cells << Cell.new(x + 1, y + 1)
      end
    end
  end

  private

  def check_ship(cells)
    cells.each { |cell| return false if cell(cell.x, cell.y)&.ship? || cell(cell.x, cell.y)&.adjoined? }
    cells.map(&:x).each { |x| return false if x > size_x || x < 1 }
    cells.map(&:y).each { |y| return false if y > size_y || y < 1 }
    true
  end

  def random_ship(length)
    x = rand(1..size_x)
    y = rand(1..size_y)
    direction = [:up, :right].sample
    Ship.new(x, y, direction, length)
  end

  def random_shot_coordinates
    if successful_shots.last&.hit?
      extreme_coordinates
    else
      [rand(1..size_x), rand(1..size_y)]
    end
  end

  def extreme_coordinates
    if successful_shots[-2]&.hit?
      shots = []
      if last_hits.first.cell.x == last_hits.last.cell.x
        last_hits.each do |shot|
          shots << [last_hits.first.cell.x, shot.cell.y + 1] if shot.cell.y < size_y
          shots << [last_hits.first.cell.x, shot.cell.y - 1] if shot.cell.y > 1
        end
      end
      if last_hits.first.cell.y == last_hits.last.cell.y
        last_hits.each do |shot|
          shots << [shot.cell.x + 1, last_hits.first.cell.y] if shot.cell.x < size_x
          shots << [shot.cell.x - 1, last_hits.first.cell.y] if shot.cell.x > 1
        end
      end
      shots.sample
    else
      successful_shots.last.cell.surrounding_coordinates.sample
    end
  end

  def last_hits
    last_hits = []
    successful_shots.each do |shot|
      last_hits << shot
      last_hits = [] unless shot.hit?
    end
    last_hits
  end

  def cell(x, y)
    @cells.select { |cell| cell.x == x && cell.y == y }.first
  end

  def successful_shots
    @shots.select { |shot| shot.hit? || shot.destroy? }
  end

  def set_adjoined(cells)
    cells.each do |cell|
      cell.adjoined_coordinates.each do |pair| 
      	cell(pair.first, pair.last)&.adjoin! unless cell(pair.first, pair.last)&.ship?
      end
    end
  end

  def retries
    (size_x + size_y) * 5
  end
end
