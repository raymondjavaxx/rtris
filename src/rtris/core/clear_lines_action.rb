# frozen_string_literal: true

module Rtris
  module Core
    class ClearLinesAction < Rtris::Action::TimelineAction
      TIMELINE = Animation::Timeline.build do |timeline|
        timeline.lane(:opacity) do |lane|
          lane.keyframe(time: 0, value: 0, easing: :ease_out_cubic)
          lane.keyframe(time: 10, value: 1)
        end
        timeline.lane(:scale) do |lane|
          lane.keyframe(time: 0, value: 0, easing: :ease_out_cubic)
          lane.keyframe(time: 10, value: 1)
          lane.keyframe(time: 10 + Constants::BOARD_WIDTH, value: 1)
        end
      end

      def initialize(rows, &completion_block)
        @rows = rows
        @completion_block = completion_block
        super(TIMELINE)
      end

      def tick
        super
        @completion_block.call if dead?
      end

      def draw(graphics)
        @rows.each do |row|
          Constants::BOARD_WIDTH.times do |col|
            scale = timeline.value_at(:scale, frame - col)
            graphics.particle.draw_rot(
              (col * Constants::BLOCK_SIZE) + (Constants::BLOCK_SIZE / 2),
              (row * Constants::BLOCK_SIZE) + (Constants::BLOCK_SIZE / 2),
              0, # z
              0, # angle
              0.5, # center_x
              0.5, # center_y
              scale, # scale_x
              scale, # scale_y
              Gosu::Color.new((timeline.value_at(:opacity, frame) * 255).to_i, 255, 255, 255)
            )
          end
        end
      end
    end
  end
end
