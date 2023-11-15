# frozen_string_literal: true

module Rtris
  module Scenes
    class Gamepad
      include Rtris::Gamepads::Xbox360
    end

    class Menu
      def initialize(window)
        @window = window

        assets_path = File.expand_path('../assets', __dir__)
        @logo = Gosu::Image.new("#{assets_path}/img/logo.png")
        @background = Gosu::Image.new("#{assets_path}/img/menu_gradient.jpg")
        @mask = Gosu::Image.new("#{assets_path}/img/menu_alpha_mask.png")
        @block_sprites = Gosu::Image.load_tiles("#{assets_path}/img/blocks.png", 32, 32, tileable: true)
        @new_game_text = Gosu::Image.new("#{assets_path}/img/new_game_text.png")

        @step = 0
        @cells = Array.new(25).map! { Array.new(40).fill { |_i| rand(8) } }
      end

      def terminate; end

      def update
        return unless (@step += 2) >= 96

        @step = 0

        3.times do
          row = @cells.pop
          row.map! { rand(8) }
          @cells.unshift row
        end
      end

      def draw
        @background.draw(0, 0, 0)

        @cells.each_with_index do |row, y|
          row.each_with_index do |cell, x|
            if cell != 0
              index = cell - 1
              @block_sprites[index].draw(x * 32, @step + (y * 32), 0)
            end
          end
        end

        @mask.draw(0, 0, 0)

        logo_x = (@window.width / 2) - (@logo.width / 2)
        @logo.draw(logo_x, 130, 0)

        return unless @step <= 45

        text_x = (@window.width / 2) - (@new_game_text.width / 2)
        @new_game_text.draw(text_x, @window.height - 107, 0)
      end

      def button_down(id)
        case id
        when Gosu::KbEscape
          @window.close
        else
          @window.scene = Game.new(@window)
        end
      end

      def button_up(id); end
    end
  end
end
