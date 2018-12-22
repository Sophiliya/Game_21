require_relative 'card'

class Deck < Card
  attr_reader :cards

  def initialize
    @cards = []

    @@ranks.each do |rank|
      @@suits.each do |suit|
        @cards << Card.new(rank, suit)
      end
    end
  end

  def shuffle
    5.times @cards.shuffle!
  end

  def distribute
    @cards.pop
  end

  def take_back(player_cards)
    player_cards.count.times do
      @cards.push(player_cards.pop)
    end
  end
end
