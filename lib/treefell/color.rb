module Treefell
  class Color
    COLORS = [
      :bright_black,
      :bright_blue,
      :bright_cyan,
      :bright_green,
      :bright_magenta,
      :bright_red,
      :bright_yellow
    ]

    def self.rotate
      if !@colors_index || @colors_index == COLORS.length - 1
        @colors_index = -1
      end
      new(COLORS[@colors_index+=1])
    end

    def initialize(color)
      @color = color
    end

    def colorize(str)
      ::Term::ANSIColor.send(@color, str)
    end
  end
end
