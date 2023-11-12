# frozen_string_literal: true

module Rtris
  class Window < Gosu::Window
    SCREEN_WIDTH  = 1280
    SCREEN_HEIGHT = 720

    def initialize
      super(SCREEN_WIDTH, SCREEN_HEIGHT, false)
      self.caption = 'Rtris'

      @scene = Rtris::Scenes::Dev.new(self)
    end

    def scene=(new_scene)
      @scene&.terminate
      @scene = new_scene
    end

    def update
      @scene.update
    end

    def draw
      @scene.draw
    end

    def button_up(id)
      @scene.button_up id
    end

    def needs_cursor?
      true
    end

    def button_down(id)
      @scene.button_down id
    end
  end
end
