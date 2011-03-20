require_relative "../utils"
require_relative "../base_events"
require_relative "../deck/_deck_header"
require_relative "_player_header"

class BasePlayer
  include Utils
  include BaseEvents
  
  event :gain_health, [:amount]
  event :lose_health, [:amount]
  event :die
  event :draw_card, [:amount, :type, :cost, :colour]
  event :discard_card, [:amount, :type, :cost, :colour]
  event :cast, [:type, :cost, :colour]
  
  attr_accessor :name
  attr_accessor :deck
  attr_reader :life
  
  def initialize(name, deck)
    self.name = name
    self.deck = Deck.load(deck)
    self.life = 20
  end

  def modify_life(amount)
    lose_health(amount.abs) if amount < 0
    gain_health(amount) if amount > 0
    self.life += amount
    die if self.life <= 0
    self.life
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
  
  protected
  
  def life=(amount)
    @life = amount
  end
end
