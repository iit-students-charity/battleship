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