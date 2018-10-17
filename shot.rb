class Shot
  attr_reader :status, :cell

  def initialize(cell)
    @cell = cell
    @status = :unperformed
  end

  def miss?
    @status == :miss
  end

  def hit?
    @status == :hit
  end

  def destroy?
    @status == :destroy
  end

  def incorrect?
    @status == :incorrect
  end

  def not_performed?
    @status == :unperformed
  end

  def perform
    shot_ship and return if @cell&.ship?
    if @cell&.empty? || @cell&.adjoined?
      miss
    else
      @status = :incorrect
    end
  end

  private
  
  def shot_ship
    @cell.ship.damage(@cell.x, @cell.y)
    @status = @cell.ship.destroyed? ? :destroy : :hit
  end

  def miss
    @cell.fired!
    @status = :miss
  end
end
