require_relative 'card'
require_relative 'deck'
require_relative 'dealer'
require_relative 'user'

class Game21
  def initialize
    @players = []
    @dealer = Dealer.new
    @players << @dealer
  end

  def start
    puts 'Hello!'

    create_user

    start_game
  end

  private

  def create_user
    puts 'Enter your name: '

    @user = User.new(gets.chomp.strip)

    @players << @user
  end

  def start_game
    card_distribution

    puts 'Game started!'

    @turn_of_player = @players.sample

    loop do
      @turn_of_player == @dealer ? dealer_action : user_action

      break if stop?

      show_to_user
    end

    stop_game
  end

  def card_distribution
    @deck = Deck.new

    puts 'Card distribution:'

    2.times do
      @user.take_card(@deck.distribute)
      @dealer.take_card(@deck.distribute)
    end

    show_to_user
  end

  def show_to_user
    puts "#{@dealer.name}'s cards: #{@dealer.show_cards_hidden}"
    puts "#{@user.name}'s cards: #{@user.show_cards}, points: #{@user.points}"
  end

  def dealer_action
    puts "Dealer's turn."

    dealer_choose_action

    @turn_of_player = @user
  end

  def dealer_choose_action
    if @dealer.points < 15 && @dealer.cards_count < 3
      @dealer.take_card(@deck.distribute)
    elsif @dealer.cards_count == 3 || @dealer.points > 18
      skip_turn(@dealer)
    else
      random_action
    end
  end

  def user_action
    case user_choose
    when 'Skip'
      skip_turn(@user)
    when 'Add card'
      @user.take_card(@deck.distribute)
    else
      @stop_game = true
    end

    @turn_of_player = @dealer
  end

  def user_choose
    show_user_actions
    actions_list[gets.chomp.strip.to_i - 1]
  end

  def show_user_actions
    puts 'Your turn. Choose your action:'
    actions_list.each.with_index(1) { |action, index| puts "#{index}. #{action}" }
  end

  def random_action
    action = ['skip', 'take'].sample

    case action
    when 'skip'
      skip_turn(@dealer)
    when 'take'
      @dealer.take_card(@deck.distribute)
    end
  end

  def actions_list
    @actions = ['Skip', 'Show cards']
    @user.cards_count < 3 ? @actions << 'Add card' : @actions
  end

  def skip_turn(player)
    puts "    #{player.name} skipped his turn."
  end

  def stop?
    @stop_game || (@dealer.cards_count == 3 && @user.cards_count == 3)
  end

  def stop_game
    puts 'Game stoppped.'

    results
    start_again?
  end

  def results
    puts "Dealer's cards: #{@dealer.show_cards}, points: #{@dealer.points}"
    puts "Your cards: #{@user.show_cards}, points: #{@user.points}"
    puts "Dead heat." if @user.points == @dealer.points

    define_winner
  end

  def define_winner
    if user_won?
      puts "Congratulations, #{@user.name}! You won!"
    else
      puts "Dealer won."
    end
  end

  def user_won?
    case_1 = @dealer.points < @user.points && @user.points <= 21
    case_2 = @user.points <= 21 && @dealer.points > 21

    case_1 || case_2
  end

  def start_again?
    case user_answer
    when 1
      clear_player_cards
      start_game
    when 2
      return p 'Bye!'
    else
      return p 'Incorrect answer. Bye!'
    end
  end

  def user_answer
    puts "#{@user.name}, do you want to play again?"
    puts '1. Yes  2. No'

    gets.chomp.strip.to_i
  end

  def clear_player_cards
    @user.cards.clear
    @dealer.cards.clear
    @stop_game = false
  end
end
