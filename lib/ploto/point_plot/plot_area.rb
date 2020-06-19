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

        nil_count = 0
        x_vector.each_with_index do |x_value, index|
          y_value = y_vector[index]
          if x_value.nil? || y_value.nil?
            nil_count += 1
          else
            container.add_element(
              'circle',
              'cx' => @x_axis.pixel_position(x_value), 
              'r'=>"3",
              'cy' => @y_axis.pixel_height - @y_axis.pixel_position(y_vector[index]),
              'fill' => '#6CD4FF' 
            )
          end
        end
        warn("Warning: #{nil_count} points were not rendered due to missing values.") if nil_count > 0

        container
      end
    end
  end
end