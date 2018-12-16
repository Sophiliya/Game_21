class Player
  attr_reader :name, :cards

  $aces = ['A♣', 'A♥', 'A♠', 'A♦']
  $numbers = ['2♣', '2♥', '2♠', '2♦', '3♣', '3♥', '3♠', '3♦', '4♣', '4♥', '4♠', '4♦',
            '5♣', '5♥', '5♠', '5♦', '6♣', '6♥', '6♠', '6♦', '7♣', '7♥', '7♠', '7♦',
            '8♣', '8♥', '8♠', '8♦', '9♣', '9♥', '9♠', '9♦', '10♣', '10♥', '10♠', '10♦']

  def initialize(name)
    @name = name
    @cards = []
  end

  def cards_count
    # return 0 if @cards.empty?
    @cards.length
  end

  def add_card(card)
    @cards << card
  end

  def show_cards
    # return if @cards.empty?
    @cards.join('  ')
  end

  def points
    return 0 if @cards.empty?

    ace_count = @cards.select { |card| $aces.include?(card) }.count

    cards_without_aces = @cards - $aces

    return ace_count if cards_without_aces.empty?

    points_without_aces = cards_without_aces.inject(0) { |sum, card| sum += $numbers.include?(card) ? card_to_number(card) : 10 }

    return points_without_aces if ace_count == 0

    if ace_count == 1 && points_without_aces + 11 <= 21
      points_without_aces + 11
    else
      points_without_aces + ace_count
    end
  end

  private 

  def card_to_number(card)
    card.length == 2 ? card[0].to_i : 10
  end
end
