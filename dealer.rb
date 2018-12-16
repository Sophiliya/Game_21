class Dealer < Player
  def initialize
    @cards = []
  end

  def show_cards_hidden
    # return if @cards.empty?
    Array.new(self.cards_count) { |i| '*' }.join('  ')
  end
end
