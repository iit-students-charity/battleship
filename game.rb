class Game
  DEFAULT_SHIP_SET = {_1: 4, _2: 3, _3: 2, _4: 1}
  DEFAULT_SETTINGS = {board_size: 10, game_mode: :player_vs_bot, ship_set: DEFAULT_SHIP_SET}

  def initialize
    @settings = DEFAULT_SETTINGS
  end

  def run
    menu
  end

  private

  def play
    case @settings[:game_mode]
    when :player_vs_bot
      player_vs_bot
    when :bot_vs_bot
      bot_vs_bot
    else
      player_vs_player
    end
  end

  def player_vs_bot
    @player = Player.new(Board.new(@settings[:board_size], @settings[:board_size]), name)
    @bot = Bot.new(Board.new(@settings[:board_size], @settings[:board_size]), Faker::GreekPhilosophers.name)
    install_player_ships(@player)
    install_ships_randomly(@bot)
    
  end

  def player_vs_player

  end

  def bot_vs_bot

  end

  def install_player_ships(player)
    system('clear')
    puts "Install your ships, #{player.name}:"
    print 'Do you want to set ships randomly? (y/n) '
    case gets.chomp
    when 'y'
      begin
        accept = false
        until accept do
          system('clear')
          player.board.reset
          install_ships_randomly(player)
          player.print
          print 'Do you accept this board? (y/n) '
          accept = true if gets.chomp == 'y'
        end
      rescue IncorrectPlaceException
        retry
      end
    else
      install_ships(player)
    end
    system('clear')
    puts 'Now your board looks like this:'
    player.print
  end

  def install_bot_ships(bot)

  end

  def install_ships(player)
    @settings[:ship_set].each do |decks, value|
      length = decks.to_s[1].to_i
      value.times do
        begin
          system('clear')
          puts "Install your #{length}-deck ships:"
          player.print
          print 'Input x coordinate: '
          x = gets.chomp.to_i
          print 'Input y coordinate: '
          y = gets.chomp.to_i
          if decks.to_s[1].to_i > 1
            print 'Input up or right direction (u/r): '
            if gets.chomp == 'r'
              direction = :right
            else
              direction = :up
            end
          else
            direction = :up
          end
          player.set_ship(Ship.new(x, y, direction, length))
        rescue IncorrectPlaceException
          retry
        end
      end
    end
  end

  def install_ships_randomly(player)
    @settings[:ship_set].each do |decks, value|
      length = decks.to_s[1].to_i
      value.times { player.set_ship_randomly(length) }
    end
  end

  def menu(status = :correct)
    print_menu_prefix(status)
    print_menu
    print_menu_postfix(status)
    case gets.chomp
    when "1"
      play
    when "2"
      settings
    when "0"
      system('clear')
      puts('Goodbye!')
      exit
    else
      menu(:incorrect)
    end
  end

  def settings(status = :correct)
    print_settings_prefix(status)
    print_settings
    print_settings_postfix(status)
    case gets.chomp
    when "1"
      board_size
    when "2"
      ship_set
    when "3"
      game_mode
    when "4"
      default_settings
    when "0"
      menu(:settings_saved)
    else
      settings(:incorrect)
    end
  end

  def board_size
    print_board_size
    size = gets.chomp.to_i
    @settings = size <= 20 ? size : 20
    settings(:board_size_updated)
  end

  def ship_set
    print_ship_set
    4.times do |decks|
      decks += 1
      puts "How many #{decks}-deck ships do you want?"
      @settings[:ship_set][('_' + decks.to_s).to_sym] = gets
    end
    settings(:ship_set_updated)
  end

  def game_mode(status = :correct)
    print_game_mode
    print_game_mode_postfix(status)
    case gets
    when "1\n"
      @settings[:game_mode] = :bot_vs_bot
    when "2\n"
      @settings[:game_mode] = :player_vs_bot
    when "3\n"
      @settings[:game_mode] = :player_vs_player
    when "0\n"
      settings
    else
      game_mode(:incorrect)
    end
    settings(:game_mode_updated)
  end

  def default_settings
    @settings = DEFAULT_SETTINGS
    settings(:default_settings_set)
  end

  def print_menu
    puts('1 | Start')
    puts('2 | Settings')
    puts('0 | Exit')
  end

  def print_menu_prefix(status)
    system('clear')
    case status
    when :settings_saved
      puts 'Settings have been updated. Main menu:'
    else
      puts 'Main menu:'
    end
  end

  def print_menu_postfix(status)
    status == :incorrect ? print('Incorrect option, please input correct one: ') : print('Input an option: ')
  end

  def print_settings
    puts('1 | Set board size')
    puts('2 | Choose a set of ships')
    puts('3 | Choose game mode')
    puts('4 | Return to default settings')
    puts('0 | Back')
  end

  def print_settings_prefix(status)
    system('clear')
    case status
    when :board_size_updated
      puts 'Board size has been updated. Settings:'
    when :ship_set_updated
      puts 'Ship set has been updated. Settings:'
    when :game_mode_updated
      puts 'Game mode has been updated. Settings:'
    when :default_settings_set
      puts 'Default settings have been set. Settings:'
    else
      puts 'Settings:'
    end
  end

  def print_settings_postfix(status)
    status == :incorrect ? print('Incorrect option, please input correct one: ') : print('Input an option: ')
  end

  def print_game_mode
    system('clear')
    puts 'Choose game mode:'
    puts '1 | Bot vs Bot'
    puts '2 | Player vs Bot'
    puts '3 | Player vs Player'
    puts '0 | Back'
  end

  def print_game_mode_postfix(status)
    status == :incorrect ? print('Incorrect option, please input correct one: ') : print('Input an option: ')
  end

  def print_board_size
    system('clear')
    puts 'Input board size (no more than 20): '
  end

  def print_ship_set
    system('clear')
    puts 'Choose ship set, think about them to fit the board!'
  end

  def name
    print 'Input your name (leave blank to random): '
    name = gets.chomp
    name = name != '' ? name.capitalize : Faker::FunnyName.name
    print "So, now you are #{name}, press any key to continue... "
    gets
    name
  end

  def bot_name
    print 'Input bot name (leave blank to random): '
    name = gets.chomp
    name = name != '' ? name.capitalize : Faker::GreekPhilosophers.name
    print "So, now this bot is #{name}, press any key to continue... "
    gets
    name
  end
end
