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
        @input = Rtris::Input.new
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
        return if @paused

        if @input.left?
          @game.move_left
        elsif @input.right?
          @game.move_right
        end

        if @input.down?
          @game.move_down
        elsif @input.hard_drop?
          @game.hard_drop
        end

        if @input.rotate?
          @game.rotate_piece(clockwise: true)
        elsif @input.rotate_ccw?
          @game.rotate_piece(clockwise: false)
        end

        @game.update
        @input.tick
      end

      def draw
        @graphics.draw_background
        if @paused
          @graphics.draw_paused
        else
          @graphics.draw_board(@game.board)
          @graphics.draw_ghost_piece(@game.ghost_piece)
          @graphics.draw_current_piece(@game.current_piece, offset: 0)
          @graphics.draw_piece_queue(@game.piece_queue)
        end
        @graphics.draw_score(@game.score)
      end

      def button_up(id)
        return if @paused
        puts id
        case id
        when Gosu::KbUp, Gamepad::ROTATE
          @input.key_released(:rotate)
        when Gosu::KB_LEFT_CONTROL, Gosu::KB_RIGHT_CONTROL, Gamepad::ROTATE_CCW
          @input.key_released(:rotate_ccw)
        when Gosu::KB_RIGHT, Gamepad::RIGHT
          @input.key_released(:right)
        when Gosu::KB_LEFT, Gamepad::LEFT
          @input.key_released(:left)
        when Gosu::KB_DOWN, Gamepad::ACCEL
          @input.key_released(:down)
        when Gosu::KB_SPACE, Gamepad::HARD_DROP
          @input.key_released(:hard_drop)
        end
      end

      def button_down(id)
        case id
        when Gosu::KB_RETURN, Gamepad::ENTER
          toggle_pause
        when Gosu::KB_ESCAPE
          @window.scene = Menu.new(@window)
        end

        return if @paused

        case id
        when Gosu::KB_ESCAPE
          @window.scene = Menu.new(@window)
        when Gosu::KB_UP, Gamepad::ROTATE
          @input.key_pressed(:rotate)
        when Gosu::KB_LEFT_CONTROL, Gosu::KB_RIGHT_CONTROL, Gamepad::ROTATE_CCW
          @input.key_pressed(:rotate_ccw)
        when Gosu::KB_RIGHT, Gamepad::RIGHT
          @input.key_pressed(:right)
        when Gosu::KB_LEFT, Gamepad::LEFT
          @input.key_pressed(:left)
        when Gosu::KB_DOWN, Gamepad::ACCEL
          @input.key_pressed(:down)
        when Gosu::KB_SPACE, Gamepad::HARD_DROP
          @input.key_pressed(:hard_drop)
        end
      end
    end
  end
end
