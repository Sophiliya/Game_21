class Player
  attr_reader :cards, :name

  def initialize(name = 'Player')
    @name = name
    @cards = []
  end

  def cards_count
    @cards.count
  end

  def add_card(card)
    @cards << card
  end

  def show_cards
    @cards.map(&:show).join('  ')
  end

  def points
    @points = @cards.inject(0) { |sum, card| sum += card.point }

    ace_point_change
  end

  protected

  def ace_count
    @cards.select { |card| card.rank == 'Ace' }.count
  end

  def ace_point_change
    ( ace_count == 1 && @points <= 21 ) ? @points : ( @points - 10 * ace_count )
  end
end
