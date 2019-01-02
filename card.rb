class Card
  attr_reader :rank, :suit

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
