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
      SDL::Mixer.open(SDL::Mixer::DEFAULT_FREQUENCY, SDL::Mixer::FORMAT_U16LSB, 2, 1024)

      sfx_dir = File.dirname(__FILE__) + "/sfx"

      #load sounds
      @bg_music = SDL::Mixer::Music.load(sfx_dir + "/midi/korobeiniki_loop.mid")
      @rotate_sfx = SDL::Mixer::Wave.load(sfx_dir + "/rotate.wav")
      @beam_sfx = SDL::Mixer::Wave.load(sfx_dir + "/beam.wav")

      #@line_voices = Array.new
      #@line_voices.push(SDL::Mixer::Wave.load(sfx_dir + "/voices/double.wav"))
      #@line_voices.push(SDL::Mixer::Wave.load(sfx_dir + "/voices/double.wav"))
      #@line_voices.push(SDL::Mixer::Wave.load(sfx_dir + "/voices/triple.wav"))
      #@line_voices.push(SDL::Mixer::Wave.load(sfx_dir + "/voices/tetris.wav"))
    end

    def start_bg_music
      SDL::Mixer.fade_in_music(@bg_music, -1, 2000)
    end

    def play_rotate
      SDL::Mixer.play_channel(1, @rotate_sfx, 0)
    end

    def play_beam
      SDL::Mixer.play_channel(2, @beam_sfx, 0)
    end

    def stop_music
      SDL::Mixer.halt_music
    end

    def play_line_voice(cleared_lines)
      #SDL::Mixer.play_channel(2, @line_voices[cleared_lines - 1], 0)
    end
  end
end
