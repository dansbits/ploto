module Ploto
  module Point
    class PlotArea
      def initialize(x_axis, y_axis)
        @x_axis = x_axis
        @y_axis = y_axis
      end

      def render(x_position, y_position, x_vector, y_vector)
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

        x_vector.each_with_index do |value, index|
          container.add_element(
            'circle',
            'cx' => @x_axis.pixel_position(value), 
            'r'=>"3",
            'cy' => @y_axis.pixel_height - @y_axis.pixel_position(y_vector[index]),
            'fill' => '#6CD4FF' 
          )
        end

        container
      end
    end
  end
end