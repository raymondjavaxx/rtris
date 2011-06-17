require 'gosu'

module Rtris
  class Window < Gosu::Window
    SCREEN_WIDTH  = 400
    SCREEN_HEIGHT = 400

    def initialize
      super SCREEN_WIDTH, SCREEN_HEIGHT, false
      self.caption = "Rtris"

      @game = Game.new
      @graphics = Graphics.new(self)
    end

    def update
      if button_down? Gosu::KbUp or button_down? Gosu::GpButton0 then
        @game.rotate_piece(true)
      end

      @game.do_physics
    end

    def draw
      @graphics.draw_background
      @graphics.draw_board(@game.board)
      @graphics.draw_ghost_piece(@game.ghost_piece)
      @graphics.draw_current_piece(@game.current_piece)
      @graphics.draw_piece_queue(@game.piece_queue)
    end

    def button_down(id)
      if id == Gosu::KbEscape
        close
      end
    end
  end

end
