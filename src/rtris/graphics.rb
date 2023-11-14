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
    SCORE_TEXT_COLOR = Gosu::Color.new(0xFF_204B6C)
    PAUSED_TEXT_COLOR = Gosu::Color.new(0xFF_FFFFFF)

    attr_reader :particle, :playfield

    def initialize(window)
      @window = window
      @font_cache = {}
      load_assets
    end

    def draw_score(score)
      Gosu.translate(438, 64) do
        label_font = font(22)
        score_font = font(48)
        label_font.draw_text_rel('SCORE', 0, 0, 0, 1.0, 0.5, 1, 1, SCORE_TEXT_COLOR)
        score_font.draw_text_rel(score.points.to_s, 0, 38, 0, 1.0, 0.5, 1, 1, SCORE_TEXT_COLOR)
      end

      small_font = font(22)
      large_font = font(72)

      Gosu.translate(438, 196) do
        small_font.draw_text_rel('LEVEL', 0, 0, 0, 1.0, 0.5, 1, 1, SCORE_TEXT_COLOR)
        large_font.draw_text_rel(score.level.to_s, 0, 48, 0, 1.0, 0.5, 1, 1, SCORE_TEXT_COLOR)
      end

      Gosu.translate(438, 360) do
        small_font.draw_text_rel('LINES', 0, 0, 0, 1.0, 0.5, 1, 1, SCORE_TEXT_COLOR)
        large_font.draw_text_rel(score.lines.to_s, 0, 48, 0, 1.0, 0.5, 1, 1, SCORE_TEXT_COLOR)
      end
    end

    def draw_current_piece(piece, offset:)
      piece.each_active_and_visible_cell do |x, y, type|
        block_x = (piece.x * Constants::BLOCK_SIZE) + (x * Constants::BLOCK_SIZE)
        block_y = (piece.y * Constants::BLOCK_SIZE) + (y * Constants::BLOCK_SIZE)
        draw_block(block_x, block_y + (Constants::BLOCK_SIZE * offset), type)
      end
    end

    def draw_ghost_piece(piece)
      piece.each_active_and_visible_cell do |x, y, _type|
        block_x = (piece.x * Constants::BLOCK_SIZE) + (x * Constants::BLOCK_SIZE)
        block_y = (piece.y * Constants::BLOCK_SIZE) + (y * Constants::BLOCK_SIZE)
        draw_ghost_block(block_x, block_y)
      end
    end

    def draw_board(board)
      board.each_active_and_visible_cell do |x, y, type|
        block_x = (x * Constants::BLOCK_SIZE)
        block_y = (y * Constants::BLOCK_SIZE)
        draw_block(block_x, block_y, type)
      end
    end

    def draw_background
      @background.draw(0, 0, 0)
    end

    def draw_piece_queue(queue, paused:)
      piece = queue.peek(0)

      Gosu.translate(897, 70) do
        label_font = font(22)
        label_font.draw_text_rel('NEXT', 0, 0, 0, 0.5, 0.5, 1, 1, SCORE_TEXT_COLOR)

        Gosu.translate(0, 75) do
          @single_piece_container.draw_rot(0, 0)
          @piece_sprites[piece.type].draw_rot(0, 0) unless paused
        end
      end

      @piece_queue_container.draw(842, 210)
      return if paused

      4.times do |i|
        piece = queue.peek(i + 1)
        x = 862
        y = 222 + (96 * i) + 26
        @piece_sprites[piece.type].draw(x, y, 0)
      end
    end

    def draw_hard_drop_trail(x:, y:, opacity:)
      screen_x = (x * Constants::BLOCK_SIZE)
      screen_y = (y * Constants::BLOCK_SIZE) - @hard_drop_trail_sprite.height
      @hard_drop_trail_sprite.draw(screen_x, screen_y, 0, 1, 1, Gosu::Color.new(opacity * 255, 255, 255, 255))
    end

    def font(size)
      @font_cache[size] ||= Gosu::Font.new(size, name: 'Arial')
    end

    private

    def draw_block(x, y, type)
      index = type - 1
      @block_sprites[index].draw(x, y, 0)
    end

    def draw_ghost_block(x, y)
      @ghost_block_sprite.draw(x, y, 0, 1, 1, Gosu::Color.new(128, 255, 255, 255))
    end

    def load_assets
      # Preload font sizes
      font_sizes = [22, 24, 32, 48, 72]
      font_sizes.each { |size| font(size) }

      assets_path = File.expand_path('assets/img', __dir__)
      @block_sprites = Gosu::Image.load_tiles(
        "#{assets_path}/blocks.png",
        Constants::BLOCK_SIZE,
        Constants::BLOCK_SIZE,
        tileable: true
      )
      @piece_sprites = Gosu::Image.load_tiles("#{assets_path}/pieces.png", 72, 44, tileable: true)
      @background = Gosu::Image.new("#{assets_path}/background.png")
      @ghost_block_sprite = Gosu::Image.new("#{assets_path}/ghost_block.png")
      @hard_drop_trail_sprite = Gosu::Image.new("#{assets_path}/hard_drop_trail.png")
      @particle = Gosu::Image.new("#{assets_path}/particle.png")
      @playfield = Gosu::Image.new("#{assets_path}/playfield.png")

      @single_piece_container = Gosu::Image.new("#{assets_path}/single_piece_container.png")
      @piece_queue_container = Gosu::Image.new("#{assets_path}/piece_queue_container.png")
    end
  end
end
