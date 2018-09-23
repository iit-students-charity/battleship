class Printer
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
        print('🔥') if cell.damaged_ship?
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
        print('🔥') if cell.damaged_ship?
        print('|')
      end
      puts
    end
  end
end
