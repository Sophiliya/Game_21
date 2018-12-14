require_relative 'player.rb'
require_relative 'dealer.rb'

class GameTwentyOne
  def initialize
    @cards = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'J+', 'J<3', 'J^', 'J<>', 'Q+', 'Q<3', 'Q^', 'Q<>', 'K+', 'K<3', 'K^', 'K<>', 'T+', 'A+', 'A<3', 'A^', 'A<>']
    @aces = ['A+', 'A<3', 'A^', 'A<>']
    @players = []
    @win = nil
  end

  def start(player_name)
    @dealer = Dealer.new
    @player = Player.new(player_name)

    @players << @dealer
    @players << @player

    2.times do
      distribute(@player)
      distribute(@dealer)
    end

    @turn_of_player = @players.sample(1) # turn doljna znat tolko igra, not players
    @turn_of_player.turn = 1

    loop do
      @turn_of_player == @dealer ? dealer_action : player_action

      if @dealer.cards_count == 3 && @player.cards_count == 3 then @stop = 1 end

      break if @stop == 1
    end

    result
  end

  private

  def distribute(player)
    card = @cards.sample(1)

    player.cards << card

    @cards.delete(card)
  end

  def skip_turn(player)
    player.turn = 0
  end

  def dealer_action
    if @dealer.points >= 13 || cards_count == 3
      skip_turn(@dealer)
      puts 'Dealer skipped his turn.'
    elsif @dealer.cards_count < 3
      distribute(@dealer)
      puts 'Dealer took card.'
    end
  end

  def player_action

  end

  def result
    if (@player.points > 21 && @dealer.points <= 21) || (@player.points < @dealer.points && @dealer.points <= 21 )
      -1
    elsif @player.points <= 21 && @player.points == @dealer.points
      0
    elsif (@player.points > @dealer.points && @dealer.points < 21) || (@player.points < 21 && @dealer.points > 21)
      1
    end
  end
end
