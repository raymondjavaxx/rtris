# frozen_string_literal: true

module Rtris
  module Scenes
    class Gamepad
      include Rtris::Gamepads::Xbox360
    end

    class Game
      def initialize(window)
        @window = window
        @sound = Rtris::Sound.new
        @graphics = Rtris::Graphics.new(window)
        @game = Rtris::Core::Game.new(@sound)
      end

      def toggle_pause!
        @game.toggle_pause!

        if @game.paused
          @sound.pause_music
        else
          @sound.play_music
        end
      end

      def terminate
        @sound.stop_music
      end

      def update
        @game.update
      end

      def draw
        @graphics.draw_background
        Gosu.translate(Constants::BOARD_OFFSET_X, Constants::BOARD_OFFSET_Y) do
          @game.draw(@graphics)
        end
        @graphics.draw_piece_queue(@game.piece_queue, paused: @game.paused)
        @graphics.draw_score(@game.score)
      end

      def button_up(id)
        return if @game.paused

        case id
        when Gosu::KbUp, Gamepad::ROTATE
          @game.input.key_released(:rotate)
        when Gosu::KB_LEFT_CONTROL, Gosu::KB_RIGHT_CONTROL, Gamepad::ROTATE_CCW
          @game.input.key_released(:rotate_ccw)
        when Gosu::KB_RIGHT, Gamepad::RIGHT
          @game.input.key_released(:right)
        when Gosu::KB_LEFT, Gamepad::LEFT
          @game.input.key_released(:left)
        when Gosu::KB_DOWN, Gamepad::ACCEL
          @game.input.key_released(:down)
        when Gosu::KB_SPACE, Gamepad::HARD_DROP
          @game.input.key_released(:hard_drop)
        end
      end

      def button_down(id)
        case id
        when Gosu::KB_RETURN, Gamepad::ENTER
          toggle_pause!
        when Gosu::KB_ESCAPE
          # @window.scene = Menu.new(@window)
          @window.close
        end

        return if @game.paused

        case id
        when Gosu::KB_UP, Gamepad::ROTATE
          @game.input.key_pressed(:rotate)
        when Gosu::KB_LEFT_CONTROL, Gosu::KB_RIGHT_CONTROL, Gamepad::ROTATE_CCW
          @game.input.key_pressed(:rotate_ccw)
        when Gosu::KB_RIGHT, Gamepad::RIGHT
          @game.input.key_pressed(:right)
        when Gosu::KB_LEFT, Gamepad::LEFT
          @game.input.key_pressed(:left)
        when Gosu::KB_DOWN, Gamepad::ACCEL
          @game.input.key_pressed(:down)
        when Gosu::KB_SPACE, Gamepad::HARD_DROP
          @game.input.key_pressed(:hard_drop)
        end
      end
    end
  end
end
