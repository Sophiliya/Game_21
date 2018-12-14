module Counter
  def sum_points
    return 0 if self.cards.empty?

    aces = ['A+', 'A<3', 'A^', 'A<>']

    ace_count = self.cards.select { |card| aces.include?(card) }.count

    cards_without_aces = self.cards - aces

    return ace_count if cards_without_aces.empty?

    points_without_aces = cards_without_aces.inject(0) { |sum, card| sum += card.class == Integer ? card : 10 }

    return points_without_aces if ace_count == 0

    if ace_count == 1 && points_without_aces + 11 <= 21
      points_without_aces + 11
    else
      points_without_aces + ace_count
    end
  end

  def cards_count
    self.cards.length
  end

  def add_card(card)
    self.cards << card
  end

  def show_cards
    self.cards.join('  ')
  end
end
