# frozen_string_literal: true

module Rtris
  module Constants
    BLOCK_SIZE = 32

    BOARD_OFFSET_X = 480
    BOARD_OFFSET_Y = -24

    BOARD_WIDTH  = 10
    BOARD_HEIGHT = 20

    BOARD_WIDTH_PX  = BOARD_WIDTH  * BLOCK_SIZE
    BOARD_HEIGHT_PX = BOARD_HEIGHT * BLOCK_SIZE
  end
end
