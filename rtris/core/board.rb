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

require 'rtris/core/block_matrix'

module Rtris::Core

  class Board

    WIDTH  = 10
    HEIGHT = 22

    include BlockMatrix

    def initialize
      @cells = Array.new(HEIGHT).map!{ Array.new(WIDTH).fill(0) }
    end

    def piece_collides?(piece, peek_x = 0, peek_y = 0)
      collides = false
      piece.each_active_cell do |x, y, cell|
        x += piece.x + peek_x
        y += piece.y + peek_y
        collides = collides || !cell_is_free?(x, y)
      end

      collides
    end

    def obstructed?
      @cells.first(2).flatten.any? { |cell| cell > 0 }
    end

    def clear_lines
      cleared_lines = 0

      HEIGHT.times do |line|
        if line_clear?(line)
          collapse(line)
          cleared_lines += 1
        end
      end

      cleared_lines
    end

    def merge_piece(piece)
      piece.each_active_cell do |x, y, cell|
        x += piece.x
        y += piece.y
        @cells[y][x] = cell
      end
    end

    def each_active_and_visible_cell(&block)
      each_active_cell do |cell_x, cell_y, cell|
        block.call(cell_x, cell_y, cell) if cell_y > 1
      end
    end

    private

    def collapse(line)
      @cells[line].fill(0)
      line.downto(1) do |i|
        @cells[i].replace(@cells[i-1])
      end

      @cells[0].fill(0)
    end

    def line_clear?(line)
      @cells[line].flatten.all? { |cell| cell > 0 }
    end

    def cell_is_free?(x, y)
      if x < 0 || x >= WIDTH
        return false
      end

      if y < 0 || y >= HEIGHT
        return false
      end

      return @cells[y][x] == 0
    end
  end
end
