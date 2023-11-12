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
        @paused = false
      end

      def toggle_pause
        @paused = !@paused

        if @paused
          @sound.pause_music
        else
          @sound.play_music
        end
      end

      def terminate
        @sound.stop_music
      end

      def update
        @game.update unless @paused
      end

      def draw
        @graphics.draw_background
        @graphics.draw_board(@game.board)
        @graphics.draw_ghost_piece(@game.ghost_piece)
        @graphics.draw_current_piece(@game.current_piece)
        @graphics.draw_piece_queue(@game.piece_queue)
        @graphics.draw_score(@game.score)
      end

      def button_up(id)
        return if @paused

        case id
        when Gosu::KbDown, Gamepad::ACCEL
          @game.down_pressed = false
        end
      end

      def button_down(id)
        case id
        when Gosu::KbReturn, Gamepad::ENTER
          toggle_pause
        when Gosu::KbEscape
          @window.scene = Menu.new(@window)
        end

        return if @paused

        case id
        when Gosu::KbEscape
          @window.scene = Menu.new(@window)
        when Gosu::KbUp, Gamepad::ROTATE
          @game.rotate_piece(clockwise: true)
        when Gamepad::ROTATE_CCW
          @game.rotate_piece(clockwise: false)
        when Gosu::KbRight, Gamepad::RIGHT
          @game.move_right
        when Gosu::KbLeft, Gamepad::LEFT
          @game.move_left
        when Gosu::KbDown, Gamepad::ACCEL
          @game.down_pressed = true
        when Gosu::KbSpace, Gamepad::HARD_DROP
          @game.hard_drop
        end
      end
    end
  end
end
