require "card"

class Deck
  class DrawFromEmptyLibrary < Exception; end

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

  attr_accessor :name
  attr_writer :library
  attr_accessor :hand
  attr_writer :graveyard
  attr_writer :exile

  attr_accessor :max_hand_size

  def library
    @library ||= []
  end

  def graveyard
    @graveyard ||= []
  end

  def exile
    @exile ||= []
  end

  def initialize(name, cards)
    self.name = name
    self.library = cards
    self.hand = Hand.new
  end

  def deck_size
    self.library.size + self.hand.size + self.graveyard.size + self.exile.size
  end

  def library_size
    self.library.size
  end

  def max_hand_size
    self.hand.max_size
  end

  def empty_library?
    library_size == 0
  end

  def shuffle_deck!
    self.library += self.hand.cards + self.graveyard + self.exile
    self.hand.empty!
    self.graveyard = []
    self.exile = []
    self.library.shuffle!
  end

  def shuffle_library!
    self.library.shuffle!
  end

  def draw!(number)
    number.times do
      raise DrawFromEmptyLibrary if empty_library?
      self.hand.cards << self.library.shift
    end
  end

  def draw_hand!
    self.shuffle_deck!
    self.draw!(7)
  end

  def mulligan!
    puts "***MULLIGAN***"
    current_hand_size = self.hand.size
    self.shuffle_deck!
    self.draw!(current_hand_size - 1)
  end

  def show_hand
    self.hand.cards.each do |card|
      puts "#{card.name} #{card.cost}#{card.cmc ? " (CMC: #{card.cmc})" : ""} (#{card.display_type})"
    end
  end

  def mulligan_if_needed
    # no land
    # all land
    # low land, high power cards
    # no creatures / high enchantments, equipment, etc

    return if self.hand.size == 3

    test_again = false
    mulligan_hand = lambda do
      self.mulligan!
      test_again = true
    end

    land_num = self.hand.cards_of_type("Land").size

    # No land or all land
    if land_num == 0 || land_num == self.hand.size
      mulligan_hand.call
    end

    # If the lowest CMC is more than double land count
    if !test_again && land_num * 2 < self.hand.lowest_cmc_card.cmc
      mulligan_hand.call
    end

    # Check for mulligan again
    return self.mulligan_if_needed if test_again
    return
  end

  def self.load(name)
    filename = "decks/#{name}.deck"

    unless File.exists?(filename)
      raise "Deck does not exist!"
    end

    cards = YAML.load_file(filename)

    deck_cards = []

    cards.each_pair do |name, card|
      amount = (card["amount"] || 1).to_i
      amount.times{deck_cards << Card.build(name, card)}
    end

    return Deck.new(name, deck_cards)
  end
end
