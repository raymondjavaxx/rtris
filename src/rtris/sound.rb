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
  class Sound
    def initialize
      sfx_dir = File.expand_path('assets/sfx', __dir__)

      # load sounds
      @bg_music = Gosu::Song.new("#{sfx_dir}/midi/korobeiniki.ogg")
      @rotate_sfx = Gosu::Sample.new("#{sfx_dir}/rotate.wav")
      @beam_sfx = Gosu::Sample.new("#{sfx_dir}/beam.wav")

      @line_voices = []
      # @line_voices.push(Gosu::Sample.new(sfx_dir + "/voices/double.wav"))
      # @line_voices.push(Gosu::Sample.new(sfx_dir + "/voices/double.wav"))
      # @line_voices.push(Gosu::Sample.new(sfx_dir + "/voices/triple.wav"))
      # @line_voices.push(Gosu::Sample.new(sfx_dir + "/voices/tetris.wav"))
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
