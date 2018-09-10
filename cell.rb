class Cell
  attr_reader :x, :y, :type

  def initialize(x, y, type = :empty)
    @x = x
    @y = y
    @type = type
  end

  def adjoined_cells_coords
    coordinates = []
    (-1..1).each do |i|
      (-1..1).each do |j|
        coordinates << [x + i, i + j] unless i == 0 && j == 0
      end
    end
    coordinates
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

  def damaged_ship!
    @type = :damaged_ship
  end

  def destroyed_ship!
    @type = :destroyed_ship
  end

  def adjoined?
    @type == :adjoined
  end

  def empty?
    @type == :empty || @type == :adjoined
  end

  def ship?
    @type == :ship
  end

  def fired?
    @type == :fired
  end

  def damaged_ship?
    @type == :damaged_ship
  end

  def destroyed_ship?
    @type == :destroyed_ship
  end
end
