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
    class Game
      attr_accessor :current_piece, :board, :piece_queue, :score, :acc, :input, :hard_drop_trails, :y_offset

      def initialize(sound)
        @sound = sound
        @sound.play_music

        @piece_queue = PieceQueue.new
        @lock_delay = LockDelay.new
        @board = Board.new
        @score = Score.new
        @input = Input.new

        @acc = 0
        @y_offset = 0
        @pre_locking = false
        @current_piece = @piece_queue.pop

        @fall_speed_cache = {}
        @hard_drop_trails = []
        @animations = []
      end

      def fall_speed
        @fall_speed_cache[@score.level] ||= begin
          seconds_per_line = (0.8 - ((@score.level - 1) * 0.007))**(@score.level - 1)
          1 / (seconds_per_line * 60)
        end
      end

      def rotate_piece(clockwise:)
        piece = @current_piece.clone
        piece.rotate(clockwise)

        @lock_delay.on_shift if @lock_delay.pre_locking? && !@board.piece_collides?(piece, 0, 1)

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

        return if @board.piece_collides?(piece)

        @sound.play_rotate
        @current_piece = piece
        @lock_delay.on_rotate
      end

      def move_right
        @sound.play_rotate if move_piece(1, 0)
      end

      def move_left
        @sound.play_rotate if move_piece(-1, 0)
      end

      def hard_drop
        origin = @current_piece.y
        @current_piece.y += 1 until @board.piece_collides?(@current_piece, 0, 1)

        @current_piece.each_top_cell do |cell_x, cell_y|
          @hard_drop_trails << HardDropTrail.new(cell_x, cell_y)
        end

        delta = @current_piece.y - origin
        @score.hard_drop delta
        lock_piece

        @animations << ShakeScreenAction.new(self)
      end

      def lock_piece
        @sound.play_beam
        @board.merge_piece(@current_piece)
        @current_piece = @piece_queue.pop

        cleared_lines = @board.clear_lines
        return unless cleared_lines.positive?

        @score.add_lines cleared_lines
        @animations << LineClearTextAnimation.new(
          Constants::BOARD_WIDTH_PX / 2,
          Constants::BOARD_HEIGHT_PX / 2,
          lines: cleared_lines,
          score: 300
        )
      end

      def ghost_piece
        ghost_piece = @current_piece.clone
        ghost_piece.y += 1 until @board.piece_collides?(ghost_piece, 0, 1)

        ghost_piece
      end

      def update
        if @input.left?
          move_left
        elsif @input.right?
          move_right
        end

        if @input.hard_drop?
          hard_drop
        elsif @input.rotate?
          rotate_piece(clockwise: true)
        elsif @input.rotate_ccw?
          rotate_piece(clockwise: false)
        end

        @input.tick
        @lock_delay.on_frame

        @hard_drop_trails.each(&:tick)
        @hard_drop_trails.reject!(&:dead?)

        @animations.each(&:tick)
        @animations.reject!(&:dead?)

        do_physics
      end

      def draw(graphics)
        Gosu.translate(0, @y_offset) do
          graphics.draw_board(@board)

          @hard_drop_trails.each do |trail|
            graphics.draw_hard_drop_trail(x: trail.x, y: trail.y, opacity: trail.opacity)
          end
        end

        graphics.draw_ghost_piece(ghost_piece)
        graphics.draw_current_piece(@current_piece, offset: 0)

        @animations.each do |animation|
          animation.draw(graphics)
        end
      end

      private

      def do_physics
        return if @lock_delay.pre_locking?

        effective_fall_speed = @input.down? ? fall_speed * 20 : fall_speed
        @acc += effective_fall_speed

        while @acc >= 1
          @acc -= 1
          @pre_locking = false

          if move_piece(0, 1)
            @score.soft_drop if true # TODO: @step == 0
          else
            @lock_delay.request_lock { lock_piece }
            # puts "obstructed" if @board.obstructed?
          end
        end
      end

      def move_piece(x_delta, y_delta)
        return false if @board.piece_collides?(@current_piece, x_delta, y_delta)

        @current_piece.x += x_delta
        @current_piece.y += y_delta
        @lock_delay.on_move

        @lock_delay.on_shift if y_delta.positive? || !@board.piece_collides?(@current_piece, x_delta, 1)

        true
      end
    end
  end
end
