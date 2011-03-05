puts Dir.pwd

unless defined?(:debugger)
  def debugger; end
end

unless defined?(:require_relative)
  def require_relative(arg); require arg; end
end

require_relative 'game'

game = Game.new

game.add_player("Bill", "Kithkin", false)
game.add_player("Ben", "Kor", true)

game.start


#bill.deck.shuffle_deck!
#bill.deck.draw_hand!
#bill.deck.show_hand
#bill.deck.mulligan_if_needed
#bill.deck.show_hand


#ben.deck.shuffle_deck!
#ben.deck.draw_hand!
#ben.deck.show_hand
#ben.deck.mulligan_if_needed
#ben.deck.show_hand
