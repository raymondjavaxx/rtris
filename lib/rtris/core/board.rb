# frozen_string_literal: true

module Rtris
  module Core
    class Board
      WIDTH  = 10
      HEIGHT = 22

      include BlockMatrix

      def initialize
        @cells = Array.new(HEIGHT).map! { Array.new(WIDTH).fill(0) }
      end

      def piece_collides?(piece, peek_x = 0, peek_y = 0)
        collides = false
        piece.each_active_cell do |x, y, _cell|
          x += piece.x + peek_x
          y += piece.y + peek_y
          collides ||= !cell_is_free?(x, y)
        end

        collides
      end

      def obstructed?
        @cells.first(2).flatten.any?(&:positive?)
      end

      def scan_lines
        rows = []

        HEIGHT.times do |line|
          rows << line if line_clear?(line)
        end

        rows
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
          @cells[i].replace(@cells[i - 1])
        end

        @cells[0].fill(0)
      end

      def line_clear?(line)
        @cells[line].flatten.all?(&:positive?)
      end

      def cell_is_free?(x, y)
        return false if x.negative? || x >= WIDTH

        return false if y.negative? || y >= HEIGHT

        (@cells[y][x]).zero?
      end
    end
  end
end
