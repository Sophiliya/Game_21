require_relative 'counter.rb'

class Dealer
  include Counter

  attr_reader :cards, :turn

  def initialize
    @cards = []
    @turn = nil
  end

  def points
    @points = self.sum_points
  end

  def show_cards_hidden
    Array.new(self.cards_count) { |i| '*' }.join('  ')
  end
end
