# frozen_string_literal: true

module Rtris
  class Sound
    def initialize
      sfx_dir = File.expand_path('assets/sfx', __dir__)

      # load sounds
      @bg_music = Gosu::Song.new("#{sfx_dir}/midi/korobeiniki.ogg")
      @rotate_sfx = Gosu::Sample.new("#{sfx_dir}/rotate.wav")
      @beam_sfx = Gosu::Sample.new("#{sfx_dir}/beam.wav")

      @line_voices = []
    end

    def play_music
      @bg_music.volume = 0.9
      @bg_music.play true
    end

    def play_rotate
      @rotate_sfx.play
    end

    def play_beam
      @beam_sfx.play
    end

    def pause_music
      @bg_music.pause
    end

    def stop_music
      @bg_music.stop
    end

    def play_line_voice(cleared_lines)
      @line_voices[cleared_lines - 1].play
    end
  end
end
