require_relative "horizontal_axis_helpers"

module Ploto
  module Axes
    class NumericHorizontalAxis
      include HorizontalAxisHelpers      
      
      attr_accessor :label
      attr_reader :pixel_width

      def initialize(min_value, max_value, label: nil, pixel_width: nil)
        @min_value = min_value
        @max_value = max_value
        self.pixel_width = pixel_width if pixel_width
        @label = label
      end

      def pixel_width=(pixels)
        @pixel_width = pixels
        @plottable_pixels = pixels * 0.94
        @padding = pixels * 0.03
      end

      def pixel_position(value)
        pct_range = (value - @min_value).to_f / (@max_value - @min_value).to_f
        (@plottable_pixels.to_f * pct_range) + @padding
      end

      def labels
        space_between = (@max_value - @min_value).to_f / 5
        @labels ||= (0..4).map do |index|
          value = @min_value + (index * space_between)
          { label: value, pixel_position: pixel_position(value) }
        end
      end
    end
  end
end