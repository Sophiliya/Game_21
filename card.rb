class Card
  include Enumerable

  attr_reader :rank, :suit

  @@ranks = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace']
  @@suits = ['♣', '♥', '♠', '♦']

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def point
    if @rank == 'Ace'
      11
    elsif @rank.to_i == 0
      10
    else
      @rank.to_i
    end
  end

  def show
    @rank + @suit
  end
end
