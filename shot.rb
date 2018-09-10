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

  def kill?
    @status == :kill
  end

  def incorrect?
    @status == :incorrect
  end

  def not_performed?
    @status == :not_performed
  end

  def perform_shot
    shot_ship if @cell.ship?
    if @cell.empty? 
      miss
    else
      @status = :incorrect
    end
    @cell
  end

private:
  
  def shot_ship
    @cell.damaged_ship!
    @status = :hit
  end

  def miss
    @cell.fired!
    @status = :miss
  end
end
