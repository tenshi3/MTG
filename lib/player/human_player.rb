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

      answer = prompt_input("Do you wish to mulligan? (y/n)", ['y', 'n'])

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

  def play_first?
    puts "Your hand:"
    self.deck.show_hand

    answer = prompt_input("Do you want to play first (p) or draw (d)?", ['p', 'd'])

    return answer == 'p'
  end

  def play!
    
  end
end
