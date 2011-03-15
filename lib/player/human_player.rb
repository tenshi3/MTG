require_relative "_player_header"

class HumanPlayer < BasePlayer
  def is_ai?
    false
  end
  
  def draw_starting_hand!
    super

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
