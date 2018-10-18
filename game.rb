class Game
  DEFAULT_SHIP_SET = {_1: 4, _2: 3, _3: 2, _4: 1}
  DEFAULT_SETTINGS = {board_size: 10, game_mode: :player_vs_bot, ship_set: DEFAULT_SHIP_SET}

  def initialize
    @settings = DEFAULT_SETTINGS
  end

  def menu(status = :correct)
    print_menu_prefix(status)
    print_menu
    print_menu_postfix(status)
    case gets
    when "1\n"
      play
    when "2\n"
      settings
    when "0\n"
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
    case gets
    when "1\n"
      board_size
    when "2\n"
      ship_set
    when "3\n"
      game_mode
    when "4\n"
      default_settings
    when "0\n"
      menu(:settings_saved)
    else
      settings(:incorrect)
    end
  end

  def play

  end

  def board_size
    print_board_size
    size = gets.to_i
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

  private

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
end
