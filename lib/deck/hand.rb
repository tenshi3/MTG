require_relative "_deck_header.rb"

class Hand
  class NoCardsInHand < Exception; end
  class NoNonLandCardsInHand < Exception; end

  attr_accessor :cards
  attr_accessor :max_size

  def initialize
    self.cards = []
    self.max_size = 7
  end

  def size
    self.cards.size
  end

  def empty?
    self.cards.empty?
  end

  def empty!
    self.cards = []
  end

  def cards_of_type(type)
    raise NoCardsInHand if self.cards.empty?

    self.cards.reject{|c|c.types.include?(type)}
  end

  def lowest_cmc_card
    raise NoCardsInHand if self.cards.empty?

    lowest_card = begin
      lowest = nil
      self.cards.each do |card|
        next if card.cmc.nil?
        lowest = card if (lowest.nil? || lowest.cmc.nil? || (lowest.cmc > card.cmc))
      end

      lowest
    end

    raise NoNonLandCardsInHand if lowest_card.nil?
    return lowest_card
  end
end