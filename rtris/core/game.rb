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

require 'rtris/core/piece_queue'
require 'rtris/core/lock_delay'
require 'rtris/core/board'
require 'rtris/core/piece'

module Rtris::Core
  class Game
    attr_accessor :current_piece, :board, :piece_queue, :down_pressed

    def initialize(sound)
      @sound = sound
      @sound.play_music

      @piece_queue = PieceQueue.new
      @lock_delay = LockDelay.new
      @board = Board.new

      @step = 0
      @total_cleared_lines = 0
      @down_pressed = false
      @pre_locking = false
      @current_piece = @piece_queue.pop
    end

    def rotate_piece(clockwise = true)
      piece = @current_piece.dclone
      piece.rotate(clockwise)

      if @lock_delay.pre_locking? && !@board.piece_collides?(piece, 0, 1)
        @lock_delay.on_shift
      end

      if @board.piece_collides?(piece)
        2.times do |i|
          i += 1

          if !@board.piece_collides?(piece, i, 0)
            # wall kick
            piece.x += i
            break
          elsif !@board.piece_collides?(piece, -i, 0)
            # wall kick
            piece.x -= i
            break
          elsif !@board.piece_collides?(piece, 0, -i)
            # floor kick
            piece.y -= i
            @lock_delay.on_shift
            break
          end
        end
      end

      unless @board.piece_collides?(piece)
        @sound.play_rotate
        @current_piece = piece
        @lock_delay.on_rotate
      end
    end

    def move_right
      @sound.play_rotate if move_piece(1, 0)
    end

    def move_left
      @sound.play_rotate if move_piece(-1, 0)
    end

    def hard_drop
      until @board.piece_collides?(@current_piece, 0, 1)
        @current_piece.y += 1
      end
      lock_piece
    end

    def lock_piece
      @sound.play_beam
      @board.merge_piece(@current_piece)
      @current_piece = @piece_queue.pop

      cleared_lines = @board.clear_lines
      if cleared_lines > 0
        #@sound.play_line_voice(cleared_lines)
      end

      @total_cleared_lines += cleared_lines
    end

    def ghost_piece
      ghost_piece = @current_piece.dclone
      until @board.piece_collides?(ghost_piece, 0, 1)
        ghost_piece.y += 1
      end

      ghost_piece
    end

    def update
      @lock_delay.on_frame
      do_physics
    end

    private
    def do_physics
      if (@step += 1) >= 30 || @down_pressed
        @step = 0
        unless move_piece(0, 1)
          @lock_delay.request_lock { lock_piece }
          # puts "obstructed" if @board.obstructed?
        end
      end
    end

    def move_piece(x_delta, y_delta)
      if @board.piece_collides?(@current_piece, x_delta, y_delta)
        return false
      end

      @current_piece.x += x_delta
      @current_piece.y += y_delta
      @lock_delay.on_move

      if y_delta > 0 || !@board.piece_collides?(@current_piece, x_delta, 1)
        @lock_delay.on_shift
      end

      return true
    end
  end

end
