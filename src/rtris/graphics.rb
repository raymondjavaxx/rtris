# frozen_string_literal: true

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
    BLOCK_WIDTH  = 32
    BLOCK_HEIGHT = 32

    BOARD_OFFSET_X = 480
    BOARD_OFFSET_Y = -24

    TEXT_COLOR = 0xff204B6C

    def initialize(window)
      @window = window
      load_assets
    end

    def draw_score(score)
      @font.draw_text_rel(score.level.to_s, 438, 257, 0, 1.0, 0.5, 1, 1, TEXT_COLOR)
      @font.draw_text_rel(score.goal.to_s, 438, 420, 0, 1.0, 0.5, 1, 1, TEXT_COLOR)
    end

    def draw_current_piece(piece)
      piece.each_active_and_visible_cell do |x, y, type|
        block_x = (piece.x * BLOCK_WIDTH)  + (x * BLOCK_WIDTH) + BOARD_OFFSET_X
        block_y = (piece.y * BLOCK_HEIGHT) + (y * BLOCK_HEIGHT) + BOARD_OFFSET_Y
        draw_block(block_x, block_y, type)
      end
    end

    def draw_ghost_piece(piece)
      piece.each_active_and_visible_cell do |x, y, _type|
        block_x = (piece.x * BLOCK_WIDTH)  + (x * BLOCK_WIDTH) + BOARD_OFFSET_X
        block_y = (piece.y * BLOCK_HEIGHT) + (y * BLOCK_HEIGHT) + BOARD_OFFSET_Y
        draw_ghost_block(block_x, block_y)
      end
    end

    def draw_board(board)
      board.each_active_and_visible_cell do |x, y, type|
        block_x = (x * BLOCK_WIDTH)  + BOARD_OFFSET_X
        block_y = (y * BLOCK_HEIGHT) + BOARD_OFFSET_Y
        draw_block(block_x, block_y, type)
      end
    end

    def draw_background
      @background.draw(0, 0, 0)
    end

    def draw_piece_queue(queue)
      piece = queue.peek(0)
      @piece_sprites[piece.type].draw(862, 128, 0)

      4.times do |i|
        piece = queue.peek(i + 1)
        x = 862
        y = 222 + (96 * i) + 26
        @piece_sprites[piece.type].draw(x, y, 0)
      end
    end

    private

    def draw_block(x, y, type)
      index = type - 1
      @block_sprites[index].draw(x, y, 0)
    end

    def draw_ghost_block(x, y)
      @ghost_block_sprite.draw(x, y, 0)
    end

    def load_assets
      @font = Gosu::Font.new(72, name: 'Arial')

      assets_path = File.expand_path('assets', __dir__)
      @block_sprites = Gosu::Image.load_tiles("#{assets_path}/img/blocks.png", BLOCK_WIDTH, BLOCK_HEIGHT,
                                              tileable: true)
      @piece_sprites = Gosu::Image.load_tiles("#{assets_path}/img/pieces.png", 72, 44, tileable: true)
      @background = Gosu::Image.new("#{assets_path}/img/background.png")
      @ghost_block_sprite = Gosu::Image.new("#{assets_path}/img/ghost_block.png")
    end
  end
end
