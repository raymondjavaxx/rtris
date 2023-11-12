# frozen_string_literal: true

module Rtris
  module Core
    class Input
      ##
      # Time in frames before DAS kicks in.
      DAS_DELAY = 10

      ##
      # Time in frames between ARR shifts.
      ARR_DELAY = 2  # frames

      DAS_STATE_INITIAL = 0
      DAS_STATE_DELAY = 1
      DAS_STATE_ARR = 2

      def initialize
        @state = {
          left: false,
          right: false,
          down: false,
          rotate: false,
          rotate_ccw: false,
          hard_drop: false
        }

        @previous_state = @state.dup
        @das_state = DAS_STATE_INITIAL
      end

      def key_pressed(key)
        @state[key] = true
        dpadize_input(key)
        @das_state = DAS_STATE_INITIAL
      end

      def key_released(key)
        @state[key] = false
      end

      def tick
        @previous_state[:left] = @state[:left]
        @previous_state[:right] = @state[:right]
        @previous_state[:down] = @state[:down]
        @previous_state[:rotate] = @state[:rotate]
        @previous_state[:rotate_ccw] = @state[:rotate_ccw]
        @previous_state[:hard_drop] = @state[:hard_drop]
        update_das_state
      end

      def left?
        return true if auto_shift? && @state[:left]

        @state[:left] && !@previous_state[:left]
      end

      def right?
        return true if auto_shift? && @state[:right]

        @state[:right] && !@previous_state[:right]
      end

      def down?
        @state[:down]
      end

      def rotate?
        @state[:rotate] && !@previous_state[:rotate]
      end

      def rotate_ccw?
        @state[:rotate_ccw] && !@previous_state[:rotate_ccw]
      end

      def hard_drop?
        @state[:hard_drop] && !@previous_state[:hard_drop]
      end

      private

      def dpadize_input(input)
        case input
        when :left
          key_released(:right)
        when :right
          key_released(:left)
        when :up
          key_released(:down)
        when :down
          key_released(:up)
        end
      end

      def auto_shift?
        @das_state == DAS_STATE_ARR && @arr_counter.zero?
      end

      def update_das_state
        if @state[:left] || @state[:right]
          case @das_state
          when DAS_STATE_INITIAL
            @das_state = DAS_STATE_DELAY
            @counter = 0
          when DAS_STATE_DELAY
            @counter += 1
            if @counter >= DAS_DELAY
              @das_state = DAS_STATE_ARR
              @arr_counter = 0
            end
          when DAS_STATE_ARR
            @arr_counter += 1
            @arr_counter = 0 if @arr_counter >= ARR_DELAY
          end
        else
          @das_state = DAS_STATE_INITIAL
        end
      end
    end
  end
end
