require_relative 'cell'
require_relative 'ship'
require_relative 'board'
require_relative 'board_printer'
require_relative 'player'
require_relative 'bot'


# require 'pry'; binding.pry


SHIPS = [ Ship.new(6, 2, :right, 4),
          Ship.new(2, 5, :right, 3),
          Ship.new(7, 5, :right, 3),
          Ship.new(2, 2, :right, 2),
          Ship.new(6, 9, :up, 2),
          Ship.new(9, 9, :up, 2),
          Ship.new(1, 7, :right, 1),
          Ship.new(1, 10, :right, 1),
          Ship.new(3, 8, :right, 1),
          Ship.new(4, 10, :right, 1) ]

board = Board.new
SHIPS.each { |ship| board.set_ship(ship) }
board.shot(1, 1)
BoardPrinter.new(board).print_ours














