require 'rtris/sound'
require 'rtris/graphics'
require 'rtris/core/game'

module Rtris::Scenes
  class Game
    def initialize(window)
      @window = window
      @sound = Rtris::Sound.new
      @graphics = Rtris::Graphics.new(window)
      @game = Rtris::Core::Game.new(@sound)    
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
      @game.down_pressed = false
    end

    def button_down(id)
      case id
      when Gosu::KbUp
        @game.rotate_piece
      when Gosu::KbRight
        @game.move_right
      when Gosu::KbLeft
        @game.move_left
      when Gosu::KbDown
        @game.down_pressed = true
      when Gosu::KbSpace
        @game.hard_drop
      end
    end
  end
end
