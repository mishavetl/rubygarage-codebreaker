require "codebreaker/version"

module Codebreaker
  class Game
    attr_reader :turns, :code

    def start(turns, length = 4)
      @turns = turns
      @length = length
      @code = generate @length
      @hints = 0
    end

    def generate(length)
      Array.new(length) { rand(1..6).to_s }.join
    end

    def guess code
      if turns == 0
        return nil
      end
      @turns -= 1
      match_code code
    end

    def find(digit)
      code.each_char.with_index do |d, i|
        if d == digit && !@matched[i]
          @matched[i] = true
          return true
        end
      end
      return false
    end

    def match_code code
      result = ''
      @matched = Array.new(@length) { false }
      code.each_char.with_index do |d, i|
        if @code[i] == d
          @matched[i] = true
          result += '+'
        elsif find(d)
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

      while true
        print '-> '
        input = gets.split
        if input[0] == 'exit'
          break
        elsif input[0] == 'reveal'
          puts game.code
        elsif input[0] == 'turns'
          begin
            turns = Integer(input[1])
          rescue ArgumentError
            puts 'Bad number format'
          rescue TypeError
            puts 'An argument needed'
          end
        elsif input[0] == 'restart'
          game.start turns
        elsif game.turns == 0
          puts 'You lost. You need to start a new game. You can reveal the code or set a new amount of turns'
        elsif input[0] == 'guess'
          if input[1].nil?
            puts 'An argument needed'
          else
            puts game.guess(input[1])
          end
        elsif input[0] == 'hint'
          puts game.hint
        else
          puts "I don't understand you"
        end
      end
    end
  end
end
