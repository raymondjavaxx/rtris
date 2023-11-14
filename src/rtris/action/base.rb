# frozen_string_literal: true

module Rtris
  module Action
    class Base
      attr_reader :frame

      def initialize
        @frame = 0
      end

      def dead?
        raise NotImplementedError
      end

      def tick
        @frame += 1
      end

      def draw(graphics); end
    end
  end
end
