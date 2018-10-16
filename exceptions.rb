class IncorrectPlaceException < StandardError
  def initialize(message = default_message)
    @message = message
  end

  private

  def default_message
    "Error. This ship cannot be placed on board."
  end
end