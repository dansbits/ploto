require_relative "horizontal_axis_helpers"

module Ploto
  module Axes
    class CategoricalHorizontalAxis

      include HorizontalAxisHelpers

      attr_accessor :label
      attr_reader :pixel_width

      def initialize(categories, label: nil, pixel_width: nil)
        @categories = categories
        self.pixel_width = pixel_width if pixel_width
        @label = label
      end

      def pixel_width=(pixels)
        @pixel_width = pixels
        @plottable_pixels = pixels * 0.94
        @padding = pixels * 0.03
      end

      def pixel_position(value)
        space_between = @pixel_width / (@categories.length + 1)
        index = @categories.index(value)
        
        ((index + 1) * space_between)
      end

      def labels
        (0..@categories.length - 1).map do |index|
          category = @categories[index]
          { label: category, pixel_position: pixel_position(category) }
        end
      end
    end
  end
end