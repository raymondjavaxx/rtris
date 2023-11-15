# frozen_string_literal: true

module Rtris
  module Core
    module BlockMatrix
      def each_cell(&block)
        @cells.each_with_index do |row, y|
          row.each_with_index do |cell, x|
            block.call(x, y, cell)
          end
        end
      end

      def each_active_cell(&block)
        each_cell do |x, y, cell|
          block.call(x, y, cell) unless cell.zero?
        end
      end
    end
  end
end
