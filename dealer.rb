require_relative 'player'

class Dealer < Player
  def initialize(name = 'Dealer')
    super
  end

  def show_cards_hidden
    self.cards.collect { '*' }.join(' ')
  end
end
