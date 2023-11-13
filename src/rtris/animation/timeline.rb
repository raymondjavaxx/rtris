# frozen_string_literal: true

module Rtris
  module Animation
    class Timeline
      def initialize(lanes)
        @lanes = lanes
      end

      def self.build(&block)
        builder = Builder.new
        block.call(builder)
        new(builder.lanes)
      end

      def value_at(lane, time)
        @lanes[lane].value_at(time)
      end

      def to_s
        string = []
        string << 'Timeline:'
        @lanes.each do |lane|
          string << "  #{lane}"
        end
        string.join("\n")
      end
    end
  end
end
