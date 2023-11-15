# frozen_string_literal: true

module Rtris
  module Action
    class TimelineAction < Base
      attr_reader :timeline

      def initialize(timeline)
        @timeline = timeline
        super()
      end

      def dead?
        frame >= @timeline.total_duration
      end
    end
  end
end
