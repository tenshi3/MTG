module Utils
  def display_status(message)
    puts "","*","* #{message}","*"
  end

  def announce(message)
    puts "[#{message}]"
  end

  def prompt_input(message, acceptable = nil)
    answer = nil

    while true do
      puts "", message
      answer = STDIN.gets.strip
      break if acceptable.nil? || acceptable.include?(answer.downcase)
    end

    return answer
  end
end
