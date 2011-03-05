require "yaml"

class Card
  attr_accessor :name
  attr_accessor :types
  attr_accessor :subtypes
  attr_accessor :power
  attr_accessor :toughness
  attr_accessor :cost
  attr_accessor :colours
  attr_accessor :keywords

  def is_land?
    self.types.include?("Land")
  end

  def is_enchantment?
    self.types.include?("Enchantment")
  end

  def is_artefact?
    self.types.include?("Artefact")
  end

  def is_creature?
    self.types.include?("Creature")
  end

  def is_instant?
    self.types.include?("Instant")
  end

  def is_sorcery?
    self.types.include?("Sorcery")
  end

  def is_planeswalker?
    self.types.include?("Planeswalker")
  end

  def subtypes
    @subtypes ||= []
  end

  def display_type
    output = types.join(" ")
    unless self.subtypes.empty?
      output += " - #{subtypes.join(" ")}"
    end
    return output
  end

  def cmc
    @cmc ||= begin
      if self.is_land?
        nil
      else
        expect_x = true
        expect_num = true
        buffer = []
        multi = true

        total = 0

        split_cost = self.cost.split("")

        split_cost.each do |value|
          # X should come first, and could be more than one
          if expect_x && value == 'x'
            next
          end
          expect_x = false

          # Numbers are expected second, and could be any number
          if expect_num
            if value =~ /\d/
              buffer << value
              next
            else
              expect_num = false
              # We place them all in a buffer, so parse out
              unless buffer.empty?
                total += buffer.join("").to_i
                buffer = []
                next
              end
            end
          end

          # If we're in a multi-part cost...
          if multi
            #...and at the end
            if value == ")"
              multi = false
              first_value, second_value = buffer.join("").split("/")

              # Check if the first part was a number - that will always be the largest part
              if first_value =~ /^\d+$/
                total += first_value.to_i
              else
                # Otherwise we just count as one
                total += 1
              end
              buffer = []
              next
            else
              # If this isn't the end, push into the buffer
              buffer << value
              next
            end
          else
            if value == "("
              multi = true
              next
            end
            total += 1
          end
        end

        total
      end
    end
  end

  def self.build(name, details)
    card = Card.new
    card.name = name
    card.types = details["types"]
    card.colours = details["colours"]
    card.keywords = details["keywords"]

    unless card.is_land?
      card.cost = details["cost"].to_s
    end

    if card.is_creature? || card.is_enchantment? || card.is_artefact? || card.is_instant?
      card.subtypes = details["subtypes"]
    end

    if card.is_creature?
      card.power = details["power"]
      card.power = details["toughness"]
    end

    return card
  end
end
