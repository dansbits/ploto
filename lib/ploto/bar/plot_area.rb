module Ploto
  module Bar
    class PlotArea

      BAR_WIDTH = 20

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
        bar_width_pixels = bar_width(x_vector)
        x_vector.each_with_index do |x_value, index|
          y_value = y_vector[index]
          if x_value.nil? || y_value.nil?
            nil_count += 1
          else
            container.add_element(
              'rect',
              'x' => @x_axis.pixel_position(x_value) - (bar_width_pixels / 2), 
              'y' => @y_axis.pixel_height - @y_axis.pixel_position(y_vector[index]),
              'height' => @y_axis.pixel_position(y_vector[index]),
              'width' => bar_width_pixels,
              'fill' => '#6CD4FF' 
            )
          end
        end
        warn("Warning: #{nil_count} points were not rendered due to missing values.") if nil_count > 0

        container
      end
      
      private
      
      def bar_width(x_vector)
        space_between_bars = @x_axis.pixel_width * 0.05
        total_filler_space = space_between_bars * (x_vector.length) + 1
        
        (@x_axis.pixel_width - total_filler_space) / x_vector.length
      end
    end
  end
end