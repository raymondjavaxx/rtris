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
    BLOCK_WIDTH  = 18
    BLOCK_HEIGHT = 18

    BOARD_OFFSET_X = 9
    BOARD_OFFSET_Y = -17

    def initialize(window)
      @window = window
      load_assets
    end

    def draw_score(score)
      @font.draw("P: " + score.points.to_s, 200, 300, 0, 1, 1, 0xff000000)
      @font.draw("L: " + score.lines.to_s, 200, 336, 0, 1, 1, 0xff000000)
    end

    def draw_current_piece(piece)
      piece.each_active_and_visible_cell do |x, y, type|
        block_x = (piece.x * BLOCK_WIDTH)  + (x * BLOCK_WIDTH) + BOARD_OFFSET_X
        block_y = (piece.y * BLOCK_HEIGHT) + (y * BLOCK_HEIGHT) + BOARD_OFFSET_Y
        draw_block(block_x, block_y, type)
      end
    end

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

    def draw_background
      @background.draw(0, 0, 0)
    end

    def draw_piece_queue(queue)
      5.times do |i|
        piece = queue.peek(i)
        x = 200
        y = 50 * i + 16
        @piece_sprites[piece.type].draw(x, y, 0)
      end
    end

    private

    def draw_block(x, y, type)
      index = type-1
      @block_sprites[index].draw(x, y, 0)
    end

    def draw_ghost_block(x, y)
      @ghost_block_sprite.draw(x, y, 0)
    end

    def load_assets
      @font = Gosu::Font.new(@window, 'Arial', 36)
      @block_sprites = Gosu::Image.load_tiles(@window, "rtris/assets/img/blocks.png", BLOCK_WIDTH, BLOCK_HEIGHT, true)
      @piece_sprites = Gosu::Image.load_tiles(@window, "rtris/assets/img/pieces.png", 72, 44, true)
      @background = Gosu::Image.new(@window, "rtris/assets/img/background.png")
      @ghost_block_sprite = Gosu::Image.new(@window, "rtris/assets/img/ghost_block.png")
    end
  end
end
