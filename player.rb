class Player
  attr_reader :cards, :name, :points

  def initialize(name = 'Player')
    @name = name
    @cards = []
  end

  def cards_count
    @cards.count
  end

  def take_card(card)
    @cards << card

    puts "    #{@name} took a card."

    count_points
  end

  def show_cards
    @cards.map(&:show).join('  ')
  end

  def count_points
    @points = @cards.map(&:point).inject(:+)

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
