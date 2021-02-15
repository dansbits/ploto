module Ploto
  module Histo
    class PlotArea
      def initialize(x_axis, y_axis)
        @x_axis = x_axis
        @y_axis = y_axis
      end

      def render(x_position, y_position, bins)
        container = REXML::Element.new 'svg'
        container.add_attributes(
          {
            'x' => x_position,
            'y' => y_position,
            'width' => @x_axis.pixel_width,
            'height' => @y_axis.pixel_height,
            'overflow' => 'visible',
            'class' => 'plot-area'
          }
        )

        bins.each do |bin|
          bin_width_in_pixels = @x_axis.pixel_position(bin[:range].end) - @x_axis.pixel_position(bin[:range].begin) - 1
          container.add_element(
            'rect',
            'x' => @x_axis.pixel_position(bin[:range].begin), 
            'y' => @y_axis.pixel_height - @y_axis.pixel_position(bin[:observations]),
            'height' => @y_axis.pixel_position(bin[:observations]),
            'width' => bin_width_in_pixels,
            'fill' => '#6CD4FF' 
          )
        end

        container
      end
    end
  end
end