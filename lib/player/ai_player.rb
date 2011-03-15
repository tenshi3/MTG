require_relative "_player_header"

class AiPlayer < BasePlayer
  def is_ai?
    true
  end

  def draw_starting_hand!
    super
    self.deck.mulligan_if_needed
  end
end
