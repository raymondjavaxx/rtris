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
  class Piece

    include BlockMatrix

    attr_accessor :x, :y, :cells, :type

    # I, J, L, O, S, T, Z
    @@cell_map = [
      [[0, 0, 0, 0], [0, 0, 0, 0], [1, 1, 1, 1], [0, 0, 0, 0]], # I
      [[2, 0, 0], [2, 2, 2], [0, 0, 0]], # J
      [[0, 0, 3], [3, 3, 3], [0, 0, 0]], # L
      [[4, 4], [4, 4]], # O
      [[0, 0, 0], [0, 5, 5], [5, 5, 0]], # S
      [[0, 6, 0], [6, 6, 6], [0, 0, 0]], # T
      [[0, 0, 0], [7, 7, 0], [0, 7, 7]] # Z
    ]

    # I, J, L, O, S, T, Z
    @@start_locations = [
      {:x => 3, :y => 0},
      {:x => 3, :y => 1},
      {:x => 3, :y => 1},
      {:x => 4, :y => 1},
      {:x => 3, :y => 0},
      {:x => 3, :y => 1},
      {:x => 3, :y => 0}
    ]

    def initialize(type)
      @x = @@start_locations[type][:x]
      @y = @@start_locations[type][:y]
      @type = type
      @cells = @@cell_map[type]
    end

    def rotate(clockwise)
      side_width = @cells.count
      temp = Array.new(side_width).map!{ Array.new(side_width) }

      if clockwise
        side_width.times do |i|
          side_width.times do |j|
            temp[j][(side_width - 1)-i] = @cells[i][j]
          end
        end
      else
        side_width.times do |i|
          side_width.times do |j|
            temp[(side_width - 1)-j][i] = @cells[i][j]
          end
        end
      end

      @cells = temp
    end

    def each_active_and_visible_cell(&block)
      each_active_cell do |cell_x, cell_y, cell|
        block.call(cell_x, cell_y, cell) if (cell_y + @y) > 1
      end
    end
  end
end
