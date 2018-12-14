require_relative 'counter.rb'

class Player
  include Counter

  attr_reader :name, :cards, :turn

  def initialize(name)
    @name = name
    @cards = []
    @turn = nil
  end

  def points
    @points = self.sum_points
  end
end
