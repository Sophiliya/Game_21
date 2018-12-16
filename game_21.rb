require_relative 'player'
require_relative 'dealer'

class Game21
  def initialize
    @cards = ['2♣', '2♥', '2♠', '2♦', '3♣', '3♥', '3♠', '3♦', '4♣', '4♥', '4♠', '4♦',
              '5♣', '5♥', '5♠', '5♦', '6♣', '6♥', '6♠', '6♦', '7♣', '7♥', '7♠', '7♦',
              '8♣', '8♥', '8♠', '8♦', '9♣', '9♥', '9♠', '9♦', '10♣', '10♥', '10♠', '10♦',
              'J♣', 'J♥', 'J♠', 'J♦', 'Q♣', 'Q♥', 'Q♠', 'Q♦', 'K♣', 'K♥', 'K♠', 'K♦',
              'A♣', 'A♥', 'A♠', 'A♦']
    @aces = ['A♣', 'A♥', 'A♠', 'A♦']
    @players = []
  end

  def start
    puts 'Hello!'

    @dealer = Dealer.new

    @players << @dealer

    puts 'Enter your name: '

    player_name = gets.chomp.strip

    return p 'Empty name was entered.' if player_name.empty?

    @player = Player.new(player_name)

    @players << @player

    start_game
  end

  private

  def start_game
    puts 'Card distribution:'

    2.times do
      distribute(@player)
      distribute(@dealer)
    end

    show_to_player

    puts 'Game started!'

    @turn_of_player = @players.sample

    @stop = 0

    loop do
      @turn_of_player == @dealer ? dealer_action : player_action

      break if @stop == 1 || (@dealer.cards_count == 3 && @player.cards_count == 3)

      show_to_player
    end

    puts 'Game stoppped.'

    results
    start_again?
  end

  def show_to_player
    puts "Dealer's cards: #{@dealer.show_cards_hidden}"
    puts "#{@player.name}'s cards: #{@player.show_cards}, points: #{@player.points}"
  end

  def distribute(player)
    card = @cards.sample

    player.cards << card

    @cards.delete(card)

    puts "    #{player_name(player)} took a card."
  end

  def skip_turn(player)
    puts "    #{player_name(player)} skipped his turn."
  end

  def dealer_action
    puts "Dealer's turn."

    if @dealer.points < 15 && @dealer.cards_count < 3
      distribute(@dealer)
    elsif @dealer.cards_count == 3 || @dealer.points > 18
      skip_turn(@dealer)
    else
      action = ['skip', 'take'].sample
      case action
      when 'skip'
        skip_turn(@dealer)
      when 'take'
        distribute(@dealer)
      end
    end

    @turn_of_player = @player
  end

  def player_action
    puts 'Your turn. Choose your action:'

    player_actions_list.each.with_index(1) { |action, index| puts "#{index}. #{action}"}

    action_index = gets.chomp.strip.to_i

    if player_actions_list[action_index - 1] == 'Skip'
      skip_turn(@player)
    elsif player_actions_list[action_index - 1] == 'Add card'
      distribute(@player)
    else
      puts 'You are going to stop the game.'
      @stop = 1
    end

    @turn_of_player = @dealer
  end

  def results
    puts "Dealer's cards: #{@dealer.show_cards}, points: #{@dealer.points}"
    puts "Your cards: #{@player.show_cards}, points: #{@player.points}"

    if (@player.points > 21 && @dealer.points <= 21) || (@player.points < @dealer.points && @dealer.points <= 21 )
      puts "Dealer won."
    elsif @player.points <= 21 && @player.points == @dealer.points
      puts "Dead heat."
    elsif (@player.points > @dealer.points && @dealer.points < 21) || (@player.points <= 21 && @dealer.points > 21)
      puts "Congratulations, #{@player.name}! You won!"
    end
  end

  def player_name(player)
    player_name = player.class == Dealer ? 'Dealer' : player.name
  end

  def player_actions_list
    @actions = ['Skip', 'Show cards']
    @player.cards_count < 3 ? @actions << 'Add card' : @actions
  end

  def start_again?
    puts "#{@player.name}, do you want to play again?"
    puts '1. Yes  2. No'

    answer = gets.chomp.strip.to_i

    case answer
    when 1
      @player.cards.clear
      @dealer.cards.clear
      start_game
    when 2
      return p 'Bye!'
    else
      return p 'Incorrect answer. Bye!'
    end
  end
end
