require 'rtris/gamepads/xbox360'

module Rtris::Scenes
  class Gamepad
    include Rtris::Gamepads::Xbox360
  end

  class Menu
    def initialize(window)
      @window = window
      @logo = Gosu::Image.new(@window, "rtris/assets/img/logo.png")
      @background = Gosu::Image.new(@window, "rtris/assets/img/menu_gradient.jpg")
      @mask = Gosu::Image.new(@window, "rtris/assets/img/menu_alpha_mask.png")
      @block_sprites = Gosu::Image.load_tiles(@window, "rtris/assets/img/blocks.png", 32, 32, true)

      @new_game_text = Gosu::Image::new(@window, "rtris/assets/img/new_game_text.png")

      @step = 0
      @cells = Array.new(25).map!{ Array.new(40).fill {|i| rand(8) } }
    end

    def terminate
    end

    def update
      if (@step += 2) >= 96
        @step = 0

        3.times do
          row = @cells.pop
          row.map! { rand(8) }
          @cells.unshift row
        end
      end
    end

    def draw
      @background.draw(0, 0, 0)

      @cells.each_with_index do |row, y|
        row.each_with_index do |cell, x|
          if cell != 0
            index = cell-1
            @block_sprites[index].draw(x*32, @step + y*32, 0)
          end
        end
      end

      @mask.draw(0, 0, 0)

      logo_x = (@window.width / 2) - (@logo.width / 2)
      @logo.draw(logo_x, 130, 0)

      if @step <= 45
        text_x = (@window.width / 2) - (@new_game_text.width / 2)
        @new_game_text.draw(text_x, @window.height - 107, 0)
      end
    end

    def button_down(id)
      case id
      when Gosu::KbEscape
      	@window.close
      when Gosu::KbReturn, Gamepad::ENTER
        @window.scene = Game.new(@window)
      end
    end

    def button_up(id)
    end
  end
end
