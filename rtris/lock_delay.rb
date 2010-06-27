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

  #TODO: move to Rtris::Piece?
  class LockDelay
    FRAMES = 15

    def initialize
      restore
    end

    def request_lock(&callback)
      @pre_locking = true
      @callback = callback
    end

    def restore
      @pre_locking = false
      reset
    end

    def reset
      @lock_delay = FRAMES
    end

    def on_frame
      decrease_lock_delay if @pre_locking
      if should_lock?
        @callback.call()
        restore
      end
    end

    def on_shift
      restore
    end

    def on_move
      reset if pre_locking?
    end

    def on_rotate
      on_move
    end

    def should_lock?
      pre_locking? && @lock_delay < 1
    end

    def pre_locking?
      @pre_locking
    end

    private
    def decrease_lock_delay
      @lock_delay -= 1
    end
  end
end
