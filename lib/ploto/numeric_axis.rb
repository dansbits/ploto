module Ploto
  class NumericAxis
    def initialize(min_value, max_value, pixel_length)
      @min_value = min_value
      @max_value = max_value
      @pixel_padding = pixel_length * 0.05
      @plottable_pixels = pixel_length * 0.9
    end

    def pixel_position(value)
      pct_range = (value - @min_value).to_f / (@max_value - @min_value).to_f
      (@plottable_pixels.to_f * pct_range) + @pixel_padding
    end

    def labels
      space_between = (@max_value - @min_value).to_f / 5
      (0..4).map do |index|
        value = @min_value + (index * space_between)
        { label: value, pixel_position: pixel_position(value) }
      end
    end
  end
end