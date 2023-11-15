# frozen_string_literal: true

module Rtris
  module Core
    class PieceQueue
      def initialize
        @pieces = []
        @random_generator = RandomGenerator.new

        5.times do
          @pieces << @random_generator.make_piece
        end
      end

      def pop
        @pieces << @random_generator.make_piece
        @pieces.shift
      end

      def peek(index = 0)
        @pieces[index]
      end
    end
  end
end
