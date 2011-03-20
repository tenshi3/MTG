unless Kernel.respond_to?(:require_relative)
  module Kernel
    def require_relative(path)
      require File.join(File.dirname(caller[0]), path.to_str)
    end
  end
end

unless Kernel.respond_to?(:debugger)
  module Kernel
    def debugger;end
  end
end

require_relative 'game'

game = Game.new

game.add_player("Bill", "Kithkin", false)
game.add_player("Ben", "Kor", true)

game.start
