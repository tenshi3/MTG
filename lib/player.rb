require_relative "deck/deck"

class Player
  attr_accessor :name
  attr_accessor :ai
  attr_accessor :deck
  attr_accessor :life

  def initialize(name, deck, ai)
    self.name = name
    self.deck = Deck.load(deck)
    self.ai = ai
    self.life = 20
  end
  
  def draw_starting_hand!
    self.deck.draw_hand!

    if ai
      self.deck.mulligan_if_needed
    else
      while true
        puts "You drew:"
        self.deck.show_hand
  
        while true do
          puts "", "Do you wish to mulligan? (y/N)"
          answer = STDIN.gets.strip
  
          if ["", "y", "n"].include?(answer.downcase)
            break
          end
        end
        
        if answer == 'y'
          self.deck.mulligan!
          if self.deck.hand.empty?
            puts "You start with an empty hand..."
            break
          end
        else
          break
        end
      end
    end
  end
end
