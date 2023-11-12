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
  module Core
    class Piece
      include BlockMatrix

      attr_accessor :x, :y, :cells, :type

      # I, J, L, O, S, T, Z
      CELL_MAP = [
        [[0, 0, 0, 0], [0, 0, 0, 0], [1, 1, 1, 1], [0, 0, 0, 0]], # I
        [[2, 0, 0], [2, 2, 2], [0, 0, 0]], # J
        [[0, 0, 3], [3, 3, 3], [0, 0, 0]], # L
        [[4, 4], [4, 4]], # O
        [[0, 0, 0], [0, 5, 5], [5, 5, 0]], # S
        [[0, 6, 0], [6, 6, 6], [0, 0, 0]], # T
        [[0, 0, 0], [7, 7, 0], [0, 7, 7]] # Z
      ].freeze

      # I, J, L, O, S, T, Z
      START_LOCATIONS = [
        { x: 3, y: 0 },
        { x: 3, y: 1 },
        { x: 3, y: 1 },
        { x: 4, y: 1 },
        { x: 3, y: 0 },
        { x: 3, y: 1 },
        { x: 3, y: 0 }
      ].freeze

      def initialize(type)
        @x = START_LOCATIONS[type][:x]
        @y = START_LOCATIONS[type][:y]
        @type = type
        @cells = CELL_MAP[type]
      end

      def rotate(clockwise)
        side_width = @cells.count
        temp = Array.new(side_width).map! { Array.new(side_width) }

        if clockwise
          side_width.times do |i|
            side_width.times do |j|
              temp[j][(side_width - 1) - i] = @cells[i][j]
            end
          end
        else
          side_width.times do |i|
            side_width.times do |j|
              temp[(side_width - 1) - j][i] = @cells[i][j]
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

      def each_top_cell(&block)
        @cells[0].count.times do |col|
          @cells.count.times do |row|
            if (@cells[row][col]).positive?
              block.call(col + @x, row + @y)
              break
            end
          end
        end
      end
    end
  end
end
