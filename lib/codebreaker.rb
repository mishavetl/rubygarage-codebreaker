require "codebreaker/version"

module Codebreaker
  class Game
    attr_reader :turns, :code

    def start(turns)
      @turns = turns
      @code = generate
      @hints = 0
    end

    def generate
      Array.new(4) { rand(1..6).to_s }.join
    end

    def guess code
      if turns == 0
        return nil
      end
      @turns -= 1
      match_code code
    end

    def match_code code
      result = ''
      code.each_char.with_index do |d, i|
        if @code.index(d) == i
          result += '+'
        elsif @code.index(d)
          result += '-'
        end
      end
      result
    end

    def hint
      if @hints < code.size
        @hints += 1
      end
      unmasked = code[0..(@hints - 1)]
      masked = code[@hints..code.size]
      unmasked + masked.chars.map { |_| '*' }.join
    end
  end

  class Console
    def start
      turns = 6
      game = Game.new
      game.start turns

      input = ''

      while true
        input = gets.split
        if game.turns == 0
          puts 'You lost. You need to start a new game. You can reveal the code or set a new amount of turns'
        elsif input[0] == 'exit'
          break
        elsif input[0] == 'guess'
          puts game.guess(input[1])
        elsif input[0] == 'hint'
          puts game.hint
        elsif input[0] == 'reveal'
          puts game.code
        elsif input[0] == 'turns'
          begin
            turns = Integer(input[1])
          rescue ArgumentError
            puts 'Bad number format'
          end
        else
          puts "I don't understand you"
        end
      end
    end
  end
end
