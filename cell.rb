class Cell
  attr_reader :x, :y, :type, :ship

  def initialize(x, y, type = :empty)
    @x = x
    @y = y
    @type = type
  end

  def adjoined_coordinates
    coordinates = []
    (-1..1).each do |i|
      (-1..1).each do |j|
        coordinates << [x + i, y + j] unless i == 0 && j == 0
      end
    end
    coordinates
  end

  def adjoin!
    @type = :adjoined
    @ship = nil
  end

  def empty!
    @type = :empty
    @ship = nil
  end

  def ship!(ship)
    @type = :ship
    @ship = ship
  end

  def fired!
    @type = :fired
    @ship = nil
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
    @type == :empty
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
