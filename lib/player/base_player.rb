require_relative "../utils"
require_relative "../deck/_deck_header"
require_relative "_player_header"

class BasePlayer
  include Utils

  attr_accessor :name
  attr_accessor :deck
  attr_accessor :life

  def initialize(name, deck)
    self.name = name
    self.deck = Deck.load(deck)
    self.life = 20
  end

  def dead?
    self.life < 0
  end

  def is_ai?
    raise NotImplementedError
  end

  def starting_turn
    if self.play_first?
      self.play!
    else
      self.draw!
    end
  end

  def play_first?
    raise NotImplementedError
  end

  def draw_starting_hand!
    display_status "#{if is_ai?; name; else; "YOU"; end;} DRAWS STARTING HAND"
    self.deck.draw_hand!
  end

  def play!
    raise NotImplementedError
  end
  
  def draw!
    begin
      self.deck.draw!(1, true)
    rescue Deck::DrawFromEmptyLibrary => e
      self.life = 0
    end
  end
end
