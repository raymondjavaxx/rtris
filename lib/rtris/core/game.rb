# frozen_string_literal: true

module Rtris
  module Core
    class Game
      attr_accessor :current_piece, :board, :piece_queue, :score, :acc, :input, :y_offset, :paused

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

        @paused = false
        @fall_speed_cache = {}
        @actions = []
        @game_over = false
      end

      def toggle_pause!
        @paused = !@paused
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
          @actions << HardDropTrail.new(cell_x, cell_y)
        end

        delta = @current_piece.y - origin
        @score.hard_drop delta
        lock_piece

        @actions << ShakeScreenAction.new(self)
      end

      def lock_piece
        @sound.play_beam
        @board.merge_piece(@current_piece)
        if @board.obstructed?
          @game_over = true
          return
          # TODO: game over animation
        end

        @current_piece = @piece_queue.pop

        rows_to_clear = @board.scan_lines
        return unless rows_to_clear.any?

        @actions << ClearLinesAction.new(rows_to_clear) do
          @board.clear_lines
        end

        @score.add_lines(rows_to_clear.size)
        @actions << LineClearTextAction.new(
          Constants::BOARD_WIDTH_PX / 2,
          Constants::BOARD_HEIGHT_PX / 2,
          lines: rows_to_clear.size,
          score: 300
        )
      end

      def ghost_piece
        ghost_piece = @current_piece.clone
        ghost_piece.y += 1 until @board.piece_collides?(ghost_piece, 0, 1)

        ghost_piece
      end

      def update
        return if @paused

        process_input unless @game_over

        @input.tick
        @lock_delay.on_frame

        @actions.each(&:tick)
        do_physics

        @actions.reject!(&:dead?)
      end

      def process_input
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
      end

      def draw(graphics)
        Gosu.translate(10, 10) do
          Gosu.translate(0, @y_offset) do
            graphics.playfield.draw(-10, -10)

            if @paused
              Gosu.translate(Constants::BOARD_WIDTH_PX / 2, Constants::BOARD_HEIGHT_PX / 2) do
                font = graphics.font(48)
                font.draw_text_rel('Pause', 0, 0, 0, 0.5, 0.5, 1, 1, Gosu::Color::WHITE)
              end
            else
              Gosu.translate(0, -Constants::BLOCK_SIZE * 2) do
                graphics.draw_board(@board)
              end
              if @game_over
                Gosu.translate(Constants::BOARD_WIDTH_PX / 2, Constants::BOARD_HEIGHT_PX / 2) do
                  font = graphics.font(48)
                  font.draw_text_rel('Game Over', 0, 0, 0, 0.5, 0.5, 1, 1, Gosu::Color::WHITE)
                end
              end
            end
          end

          unless @paused
            Gosu.translate(0, -Constants::BLOCK_SIZE * 2) do
              graphics.draw_ghost_piece(ghost_piece)
              graphics.draw_current_piece(@current_piece, offset: 0)
              @actions.each do |animation|
                animation.draw(graphics)
              end
            end
          end
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
            @score.soft_drop if @input.down?
          else
            @lock_delay.request_lock { lock_piece }
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