# frozen_string_literal: true

module Rtris
  module Animation
    class Builder
      def initialize
        @lanes = {}
        @current_lane = nil
      end

      def lanes
        @lanes.freeze
      end

      def lane(name, &block)
        @current_lane = []
        block.call(self)
        @lanes[name] = Lane.new(@current_lane)
      end

      def keyframe(time:, value:, easing: :linear)
        @current_lane << Keyframe.new(time: time, value: value, easing: easing)
      end
    end
  end
end
