require_relative 'card'
require_relative 'deck'
require_relative 'dealer'
require_relative 'user'

class Game21
  def initialize
    @players = []
  end

  def start
    puts 'Hello!'

    create_dealer
    create_user

    start_game
  end

  private

  def create_dealer
    @dealer = Dealer.new
    @players << @dealer
  end

  def create_user
    @user = User.new(get_user_name)
    @players << @user
  end

  def get_user_name
    puts 'Enter your name:'
    gets.chomp.strip
  end

  def start_game
    puts "Game started!"

    create_deck
    card_distribution

    show_to_user

    @players.sample == @dealer ? dealer_action : user_action
  end

  def create_deck
    @deck = Deck.new
    clear_player_cards
  end

  def card_distribution
    puts 'Card distribution:'

    2.times do
      take_card(@dealer)
      take_card(@user)
    end
  end

  def show_to_user
    puts "#{@dealer.name}'s cards: #{@dealer.show_cards_hidden}"
    puts "#{@user.name}'s cards: #{@user.show_cards}, points: #{@user.count_points}"
  end

  def dealer_action
    puts " => Dealer's turn."
    dealer_choice
    show_to_user

    give_turn_to(@user)
  end

  def dealer_choice
    if @dealer.points < 15 && @dealer.cards_count < 3
      take_card(@dealer)
    elsif @dealer.cards_count == 3 || @dealer.points > 18
      skip_turn(@dealer)
    else
      [ skip_turn(@dealer), take_card(@dealer) ].sample
    end
  end

  def user_action
    show_available_actions
    user_choice = @actions[gets.chomp.strip.to_i - 1]

    return stop_game if user_choice == 'Show cards'
    user_choice == 'Skip' ? skip_turn(@user) : take_card(@user)

    show_to_user

    give_turn_to(@dealer)
  end

  def show_available_actions
    puts ' => Your turn. Choose your action:'

    @actions = ['Skip', 'Show cards']
    @user.cards_count < 3 ? @actions << 'Add card' : @actions
    @actions.each.with_index(1) { |action, index| puts "#{index}. #{action}" }
  end

  def give_turn_to(player)
    return stop_game if ( @dealer.cards_count == 3 && @user.cards_count == 3 )
    player == @user ? user_action : dealer_action
  end

  def take_card(player)
    player.take_card(@deck.distribute)
    player.count_points

    puts "    #{player.name} took a card."
  end

  def skip_turn(player)
    puts "    #{player.name} skipped his turn."
  end

  def stop_game
    puts 'Game stoppped.'

    results
    start_again?
  end

  def results
    puts "Dealer's cards: #{@dealer.show_cards}, points: #{@dealer.points}"
    puts "Your cards: #{@user.show_cards}, points: #{@user.points}"

    show_winner
  end

  def show_winner
    players = @players.reject { |player| player.points > 21 }

    return puts "Dead heat." if players.empty? || points_equal?

    if players.max_by(&:points) == @user
      puts "Congratulations, #{@user.name}! You won!"
    else
      puts "Dealer won."
    end
  end

  def points_equal?
    @user.points == @dealer.points
  end

  def start_again?
    answer_to_start == 1 ? start_game : end_game
  end

  def answer_to_start
    ask_to_start
    gets.chomp.strip.to_i
  end

  def ask_to_start
    puts "#{@user.name}, do you want to play again?"
    puts 'Enter the number:  1. Yes  2. No'
  end

  def clear_player_cards
    @user.cards.clear
    @dealer.cards.clear
  end

  def end_game
    puts "Bye #{@user.name}!"
  end
end
