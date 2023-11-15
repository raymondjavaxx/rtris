# frozen_string_literal: true

module Rtris
  module Core
    # Random Generator (Bag of seven)
    class RandomGenerator
      def initialize
        fill_bag
      end

      def make_piece
        fill_bag if @bag.empty?
        Piece.new(@bag.pop)
      end

      private

      def fill_bag
        @bag = (0..6).to_a.sort_by { rand }
      end
    end
  end
end
