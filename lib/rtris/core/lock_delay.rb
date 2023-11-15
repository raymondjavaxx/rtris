# frozen_string_literal: true

module Rtris
  module Core
    # TODO: move to Rtris::Piece?
    class LockDelay
      FRAMES = 15

      def initialize
        restore
      end

      def request_lock(&callback)
        @pre_locking = true
        @callback = callback
      end

      def restore
        @pre_locking = false
        reset
      end

      def reset
        @lock_delay = FRAMES
      end

      def on_frame
        decrease_lock_delay if @pre_locking
        return unless should_lock?

        @callback.call
        restore
      end

      def on_shift
        restore
      end

      def on_move
        reset if pre_locking?
      end

      def on_rotate
        on_move
      end

      def should_lock?
        pre_locking? && @lock_delay < 1
      end

      def pre_locking?
        @pre_locking
      end

      private

      def decrease_lock_delay
        @lock_delay -= 1
      end
    end
  end
end
