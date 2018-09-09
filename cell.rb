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