require_relative 'cell'
require_relative 'ship'
require_relative 'board'
require_relative 'board_printer'
require_relative 'player'
require_relative 'bot'
require_relative 'exceptions'

require 'pry'




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

bot_board = Board.new
bot = Bot.new(bot_board)
# player_board = Board.new
# player = Player.new(player_board)

SHIPS.each do |ship|
  # player.set_ship(ship)
  bot.set_ship(ship.length)
end

bot.print
# player.print

# refactor bot
# shot
# random_shot
# bot shooting
