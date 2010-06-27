# Copyright (c) 2010 Ramon E. Torres
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

module Rtris
  class Graphics
    SCREEN_WIDTH  = 400
    SCREEN_HEIGHT = 400

    BLOCK_WIDTH  = 18
    BLOCK_HEIGHT = 18

    BOARD_OFFSET_X = 9
    BOARD_OFFSET_Y = -17

    def initialize
      SDL.init(SDL::INIT_VIDEO)
      @screen = SDL::set_video_mode(SCREEN_WIDTH, SCREEN_HEIGHT, 32, SDL::SWSURFACE)

      SDL::WM.set_caption("Rtris", "Rtris")
      SDL::WM.icon = SDL::Surface.load(File.dirname(__FILE__) + "/img/icon.png")
      load_assets
    end

    def draw_current_piece(piece)
      piece.each_active_and_visible_cell do |x, y, type|
        block_x = (piece.x * BLOCK_WIDTH)  + (x * BLOCK_WIDTH) + BOARD_OFFSET_X
        block_y = (piece.y * BLOCK_HEIGHT) + (y * BLOCK_HEIGHT) + BOARD_OFFSET_Y
        draw_block(block_x, block_y, type)
      end
    end

    #TODO: merge with draw_current_piece() 
    def draw_ghost_piece(piece)
      piece.each_active_and_visible_cell do |x, y, type|
        block_x = (piece.x * BLOCK_WIDTH)  + (x * BLOCK_WIDTH) + BOARD_OFFSET_X
        block_y = (piece.y * BLOCK_HEIGHT) + (y * BLOCK_HEIGHT) + BOARD_OFFSET_Y
        draw_ghost_block(block_x, block_y)
      end
    end

    def draw_board(board)
      board.each_active_and_visible_cell do |x, y, type|
        block_x = (x * BLOCK_WIDTH)  + BOARD_OFFSET_X
        block_y = (y * BLOCK_HEIGHT) + BOARD_OFFSET_Y;
        draw_block(block_x, block_y, type)
      end
    end

    def begin_drawing
      SDL.blit_surface(@background, 0, 0, @background.w, @background.h, @screen, 0, 0)
    end

    def end_drawing
      @screen.flip
    end

    def draw_piece_queue(queue)
      5.times do |i|
        piece = queue.peek(i)
        piece.each_active_cell do |x, y, type|
          block_x = (x * 16) + 200
          block_y = (y * 16) + (50 * i) + 20
          draw_block(block_x, block_y, type)
        end
      end
    end

    private

    def draw_block(x, y, type)
      src_rect = [(BLOCK_WIDTH*(type-1)), 0, BLOCK_WIDTH, BLOCK_HEIGHT]
      dst_coords = [x, y]
      SDL.blit_surface2(@blocks_sprite, src_rect, @screen, dst_coords)
    end

    def draw_ghost_block(x, y)
      SDL.blit_surface(@ghost_block_sprite, 0, 0, BLOCK_WIDTH, BLOCK_HEIGHT, @screen, x, y)
    end

    def load_assets
      img_dir = File.dirname(__FILE__) + "/img"

      @blocks_sprite = SDL::Surface.load(img_dir + "/blocks.png")
      @background = SDL::Surface.load(img_dir + "/background.png")

      @ghost_block_sprite = SDL::Surface.load(img_dir + "/ghost_block.png")
      @ghost_block_sprite.set_color_key(SDL::SRCCOLORKEY, @ghost_block_sprite.map_rgb(255, 0, 255))
      @ghost_block_sprite.set_alpha(SDL::SRCALPHA, 120)
    end
  end
end
