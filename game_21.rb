require_relative 'card'
require_relative 'deck'
require_relative 'dealer'
require_relative 'user'

class Game21
  def initialize
    @players = []
    @deck = Deck.new
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

    name = gets.chomp.strip

    @user = User.new(name)

    @players << @user
  end

  def start_game
    card_distribution

    puts 'Game started!'

    @turn_of_player = @players.sample

    @stop = 0

    loop do
      @turn_of_player == @dealer ? dealer_action : user_action

      break if @stop == 1 || (@dealer.cards_count == 3 && @user.cards_count == 3)

      show_to_user
    end

    stop_game
  end

  def card_distribution
    @deck.shuffle

    puts 'Card distribution:'

    2.times do
      @user.add_card(@deck.distribute)
      @dealer.add_card(@deck.distribute)
    end

    show_to_user
  end

  def show_to_user
    puts "#{@dealer.name}'s cards: #{@dealer.show_cards_hidden}"
    puts "#{@user.name}'s cards: #{@user.show_cards}, points: #{@user.points}"
  end

  def dealer_action
    puts "Dealer's turn."

    if @dealer.points < 15 && @dealer.cards_count < 3
      give_card(@dealer)
    elsif @dealer.cards_count == 3 || @dealer.points > 18
      skip_turn(@dealer)
    else
      random_action
    end

    @turn_of_player = @user
  end

  def user_action
    puts 'Your turn. Choose your action:'

    user_actions_list.each.with_index(1) { |action, index| puts "#{index}. #{action}"}

    action_index = gets.chomp.strip.to_i

    if user_actions_list[action_index - 1] == 'Skip'
      skip_turn(@user)
    elsif user_actions_list[action_index - 1] == 'Add card'
      give_card(@user)
    else
      puts 'You are going to stop the game.'
      @stop = 1
    end

    @turn_of_player = @dealer
  end

  def random_action
    action = ['skip', 'take'].sample

    case action
    when 'skip'
      skip_turn(@dealer)
    when 'take'
      give_card(@dealer)
    end
  end

  def user_actions_list
    @actions = ['Skip', 'Show cards']
    @user.cards_count < 3 ? @actions << 'Add card' : @actions
  end

  def give_card(player)
    player.cards << @deck.distribute

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

    if (@user.points > 21 && @dealer.points <= 21) || (@user.points < @dealer.points && @dealer.points <= 21 )
      puts "Dealer won."
    elsif @user.points <= 21 && @user.points == @dealer.points
      puts "Dead heat."
    elsif (@user.points > @dealer.points && @dealer.points < 21) || (@user.points <= 21 && @dealer.points > 21)
      puts "Congratulations, #{@user.name}! You won!"
    end
  end

  def start_again?
    puts "#{@user.name}, do you want to play again?"
    puts '1. Yes  2. No'

    answer = gets.chomp.strip.to_i

    case answer
    when 1
      @deck.take_back(@user.cards)
      @deck.take_back(@dealer.cards)
      start_game
    when 2
      return p 'Bye!'
    else
      return p 'Incorrect answer. Bye!'
    end
  end
end
