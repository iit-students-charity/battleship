class Shot
  attr_reader :status

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
    @status == :not_performed
  end

  def perform
    shot_ship if @cell.ship?
    if @cell.empty? 
      miss
    else
      @status = :incorrect
    end
  end

private:
  
  def shot_ship
    @cell.ship.damage(@cell.x, @cell.y)
    if @cell.ship.destroyed?
      @status = :destroy
    else
      @status = :hit
    end
  end

  def miss
    @cell.fired!
    @status = :miss
  end
end
