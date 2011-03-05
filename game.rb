require "player"

class Game
  attr_accessor :players

  def initialize
    self.players = []
  end

  def add_player(name, deck, ai)
    self.players << Player.new(name, deck, ai)
  end

  def start
    puts "FINDING STARTING PLAYER"
    player_to_start_index, player_to_start = find_starting_player!

    sort_players_into_turn_order!(player_to_start_index)

    puts ""

    self.players.each do |player|
      if player.ai
        puts "#{player.name.upcase} DRAWS A STARTING HAND"
      else
        puts "YOU DRAW YOUR STARTING HAND"
      end

      player.draw_starting_hand!
    end
  end

  private

  def sort_players_into_turn_order!(start_index)
    while start_index != 0
      start_index -= 1
      self.players << self.players.shift
    end
  end

  def find_starting_player!
    roll_for_players = lambda do |players_to_roll|
      rolls = []
      player_index = 0
      players_to_roll.size.times do
        roll = (rand * 21).floor
        rolls << roll
        puts " * #{players_to_roll[player_index].name} rolls #{roll}"
        player_index += 1
      end

      max_roll = rolls.max

      players_with_max_roll = []
      rolls.each_with_index do |val, ind|
        if val == max_roll
          players_with_max_roll << ind
        end
      end

      if players_with_max_roll.one?
        winning_player_index = players_with_max_roll.first
        winning_player = players_to_roll[winning_player_index]
        puts " * #{winning_player.name} wins the roll"
        return [players_with_max_roll.first, winning_player]
      else
        winning_players = players_with_max_roll.map{|ind| players_to_roll[ind]}
        puts " * #{winning_players[0..-2].map(&:name).join(", ")} and #{winning_players.last.name} to roll again"
        return roll_for_players.call(winning_players)
      end
    end

    return roll_for_players.call(self.players)
  end
end
