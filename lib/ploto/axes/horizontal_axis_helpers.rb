module Ploto
  module Axes
    module HorizontalAxisHelpers

      TICK_HEIGHT = 3
      TICK_PADDING = 3
      LABEL_TOP_PADDING = 10

      def pixel_height
        height = CHARACTER_HEIGHT / 2.0 + TICK_HEIGHT + TICK_PADDING
        if @label
          height += CHARACTER_HEIGHT / 2.0 + LABEL_TOP_PADDING
        end
        height
      end

      def axis_label
        axis_label = REXML::Element.new 'text'
        axis_label.add_attributes(
          {
              'class' => 'axis-label',
              'x' => '50%', 
              'y' => TICK_HEIGHT + TICK_PADDING + CHARACTER_HEIGHT + LABEL_TOP_PADDING, 
              'dx' => -(CHARACTER_WIDTH * @label.length) / 2.0
            }
        )

        axis_label.text = @label

        axis_label
      end

      def render(x,y)
        container = REXML::Element.new 'svg'
        container.add_attributes({
          'x' => x,
          'y' => y,
          'width' => @pixel_width,
          'height' => pixel_height,
          'overflow' => 'visible',
          'class' => 'horizontal-axis'
        })

        container.add_element(
          'line', 
          {
            "class" => "axis-line",
            "style" => "stroke: #000000;",
            "stroke-width" => "1",
            "x1" => 0,
            "y1" => 0,
            "x2" => @pixel_width,
            "y2" => 0
          }
        )

        labels.each do |tick_label|
          # Vertical lines for x-ticks are rendered to the right of the x position. Using one pixel to the left centers
          # the x tick in line with the points on the chart
          x_position = tick_label[:pixel_position]

          el = container.add_element(
            'text', 
            {
              'x' => x_position, 
              'y' => TICK_HEIGHT + TICK_PADDING + CHARACTER_HEIGHT / 2.0,
              "class" => "tick-label",
              "style" => "text-anchor: middle;"
            }
          )
          el.text = tick_label[:label]

          container.add_element(
            'line', 
            {
              'class' => "tick-mark",
              'style' => "stroke: #000000; stroke-width: 1px;",
              'x1' => x_position,
              'y1' => 0,
              'x2' => x_position,
              'y2' => TICK_HEIGHT
            }
          )
        end

        container.add_element(axis_label) if @label

        container
      end
    end
  end
end