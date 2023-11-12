# frozen_string_literal: true

module Rtris
  module Scenes
    class Dev
      def initialize(window)
        @window = window
        @input = Input.new
        @x = 0
        @y = 0
      end

      def terminate; end

      def update
        if @input.right?
          @x += 64
        elsif @input.left?
          @x -= 64
        elsif @input.down?
          @y += 64
        end
        @input.tick
      end

      def draw
        @window.draw_quad(
          @x + 0,  @y + 0,  Gosu::Color::RED,
          @x + 0,  @y + 64, Gosu::Color::RED,
          @x + 64, @y + 64, Gosu::Color::RED,
          @x + 64, @y + 0,  Gosu::Color::RED
        )
      end

      def button_down(id)
        case id
        when Gosu::KbEscape
          @window.close
        when Gosu::KbUp, Gamepads::Xbox360::ROTATE
          @input.key_pressed(:rotate)
        when Gamepads::Xbox360::ROTATE_CCW
          @input.key_pressed(:rotate_ccw)
        when Gosu::KbRight, Gamepads::Xbox360::RIGHT
          @input.key_pressed(:right)
        when Gosu::KbLeft, Gamepads::Xbox360::LEFT
          @input.key_pressed(:left)
        when Gosu::KbDown, Gamepads::Xbox360::ACCEL
          @input.key_pressed(:down)
        when Gosu::KbSpace, Gamepads::Xbox360::HARD_DROP
          @input.key_pressed(:hard_drop)
        end
      end

      def button_up(id)
        case id
        when Gosu::KbUp, Gamepads::Xbox360::ROTATE
          @input.key_released(:rotate)
        when Gamepads::Xbox360::ROTATE_CCW
          @input.key_released(:rotate_ccw)
        when Gosu::KbRight, Gamepads::Xbox360::RIGHT
          @input.key_released(:right)
        when Gosu::KbLeft, Gamepads::Xbox360::LEFT
          @input.key_released(:left)
        when Gosu::KbDown, Gamepads::Xbox360::ACCEL
          @input.key_released(:down)
        when Gosu::KbSpace, Gamepads::Xbox360::HARD_DROP
          @input.key_released(:hard_drop)
        end
      end
    end
  end
end
