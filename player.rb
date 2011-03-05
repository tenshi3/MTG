require "deck"

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
      puts "You drew:"
      self.deck.show_hand

      while true do
        puts "", "Do you wish to mulligan? (y/N)"
        answer = STDIN.gets.strip

        if ["", "y", "n"].include?(answer.downcase)
          break
        else
          puts "What?"
        end
      end

      puts 'asdf'
    end
  end
end
