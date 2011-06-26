require 'rtris/sound'
require 'rtris/graphics'
require 'rtris/core/game'
require 'rtris/gamepads/xbox360'

module Rtris::Scenes
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

    def terminate
      @sound.stop_music
    end

    def update
      @game.update
    end

    def draw
      @graphics.draw_background
      @graphics.draw_board(@game.board)
      @graphics.draw_ghost_piece(@game.ghost_piece)
      @graphics.draw_current_piece(@game.current_piece)
      @graphics.draw_piece_queue(@game.piece_queue)
    end

    def button_up(id)
      case id
      when Gosu::KbDown, Gamepad::ACCEL
        @game.down_pressed = false
      end
    end

    def button_down(id)
      case id
      when Gosu::KbEscape
      	@window.scene = Menu.new(@window)
      when Gosu::KbUp, Gamepad::ROTATE
        @game.rotate_piece
      when Gamepad::ROTATE_CCW
        @game.rotate_piece false
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
