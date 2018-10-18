class Game
  attr_reader :settingss

  DEFAULT_SHIP_SET = {_1: 4, _2: 3, _3: 2, _4: 1}
  DEFAULT_SETTINGS = {board_size: 10, game_mode: :player_vs_bot, ship_set: DEFAULT_SHIP_SET}

  def initialize
    @settings = Hash.new(DEFAULT_SETTINGS)
  end

  def run
    begin
      menu
    rescue IncorrectPlaceException
      system('clear')
      puts "This ship set cannot be placed on board with size #{@settings[:board_size]}"
      print "Press any key and change settings... "
      gets
      retry
    end
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
    turn = :player
    loop do
      system('clear')
      break if @bot.defeated? || @player.defeated?
      puts "#{@player.name} VS #{@bot.name}"
      puts "#{@player.name} score: #{@player.score}"
      puts "#{@bot.name} score: #{@bot.score}"
      @player.print
      @bot.print_hidden
      if turn == :player
        puts "#{@player.name} turn:"
        puts 'Input x coordinate to shot: '
        x = gets.chomp.to_i
        puts 'Input y coordinate to shot: '
        y = gets.chomp.to_i
        shot = @bot.shot_on(x, y)
        if shot.hit? || shot.destroy?
          @player.increase_score
        else
          @player.decrease_score
          turn = :bot
        end
        turn = :player if shot.incorrect?
        next
      else
        shot = @player.random_shot_on
        puts "#{@bot.name} turn, it shooted at #{shot.cell.x}, #{shot.cell.y}"
        system('sleep 2')
        if shot.hit? || shot.destroy?
          @bot.increase_score
        else
          @bot.decrease_score
          turn = :player
        end
        turn = :bot if shot.incorrect?
        next
      end
    end
    @player.defeated? ? print_winner(@bot) : print_winner(@player)
  end

  def player_vs_player

  end

  def bot_vs_bot
    @first_bot = Bot.new(Board.new(@settings[:board_size], @settings[:board_size]), bot_name)
    @second_bot = Bot.new(Board.new(@settings[:board_size], @settings[:board_size]), bot_name)
    install_ships_randomly(@first_bot)
    install_ships_randomly(@second_bot)
    turn = :first
    loop do
      system('clear')
      break if @first_bot.defeated? || @second_bot.defeated?
      puts "#{@first_bot.name} VS #{@second_bot.name}"
      puts "#{@first_bot.name} score: #{@first_bot.score}"
      puts "#{@second_bot.name} score: #{@second_bot.score}"
      @first_bot.print
      @second_bot.print
      if turn == :first
        shot = @second_bot.random_shot_on
        puts "#{@first_bot.name} turn, it shooted at #{shot.cell.x}, #{shot.cell.y}"
        system('sleep 0.3')
        if shot.hit? || shot.destroy?
          @first_bot.increase_score
        else
          @first_bot.decrease_score
          turn = :second
        end
        turn = :first if shot.incorrect?
        next
      else
        shot = @first_bot.random_shot_on
        puts "#{@second_bot.name} turn, it shooted at #{shot.cell.x}, #{shot.cell.y}"
        system('sleep 0.3')
        if shot.hit? || shot.destroy?
          @second_bot.increase_score
        else
          @second_bot.decrease_score
          turn = :first
        end
        turn = :second if shot.incorrect?
        next
      end
    end
    @first_bot.defeated? ? print_winner(@first_bot) : print_winner(@second_bot)
  end

  def install_player_ships(player)
    system('clear')
    puts "Install your ships, #{player.name}:"
    print 'Do you want to set ships randomly? (y/n) '
    case gets.chomp
    when 'y'
      begin
        loop do
          system('clear')
          player.board.reset
          install_ships_randomly(player)
          player.print
          print 'Do you accept this board? (y/n) '
          break if gets.chomp == 'y'
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
    print_current_settings
    print_menu_postfix(status)
    case gets.chomp
    when '1'
      play
    when '2'
      settings
    when '0'
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
    print_current_settings
    print_settings_postfix(status)
    case gets.chomp
    when '1'
      board_size
    when '2'
      ship_set
    when '3'
      game_mode
    when '4'
      default_settings
    when '0'
      menu(:settings_saved)
    else
      settings(:incorrect)
    end
  end

  def board_size
    print_board_size
    size = gets.chomp.to_i
    @settings[:board_size] = size <= 20 ? size : 20
    settings(:board_size_updated)
  end

  def ship_set
    print_ship_set
    4.times do |decks|
      decks += 1
      puts "How many #{decks}-deck ships do you want?"
      @settings[:ship_set][('_' + decks.to_s).to_sym] = gets.chomp.to_i
    end
    settings(:ship_set_updated)
  end

  def game_mode(status = :correct)
    print_game_mode
    print_game_mode_postfix(status)
    case gets.chomp
    when "1"
      @settings[:game_mode] = :bot_vs_bot
    when "2"
      @settings[:game_mode] = :player_vs_bot
    when "3"
      @settings[:game_mode] = :player_vs_player
    when "0"
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
    system('clear')
    print 'Input your name (leave blank to random): '
    name = gets.chomp
    name = name != '' ? name.capitalize : Faker::FunnyName.name
    print "So, now you are #{name}, press any key to continue... "
    gets
    name
  end

  def bot_name
    system('clear')
    print 'Input bot name (leave blank to random): '
    name = gets.chomp
    name = name != '' ? name.capitalize : Faker::GreekPhilosophers.name
    print "So, now this bot is #{name}, press any key to continue... "
    gets
    name
  end

  def print_winner(player)
    puts "#{player.name} win with #{player.score} score!"
    print 'Press any key to return to main menu... '
    gets
    menu
  end

  def print_current_settings
    puts 'Current settings:'
    game_mode = case @settings[:game_mode]
                when :player_vs_bot
                  'Player vs Bot'
                when :bot_vs_bot
                  'Bot vs Bot'
                else
                  'Player vs Player'
                end
    puts "Game mode: #{game_mode}"
    puts "Board size: #{@settings[:board_size]}"
    puts 'Set of ships:'
    puts "    4-deck: #{@settings[:ship_set][:_4]}"
    puts "    3-deck: #{@settings[:ship_set][:_3]}"
    puts "    2-deck: #{@settings[:ship_set][:_2]}"
    puts "    1-deck: #{@settings[:ship_set][:_1]}"
  end
end
