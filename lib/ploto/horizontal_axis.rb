module Ploto
  class HorizontalAxis

    CHARACTER_HEIGHT = 18
    CHARACTER_WIDTH = 9.9055
    TICK_HEIGHT = 3
    TICK_PADDING = 3
    LABEL_TOP_PADDING = 10
    
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

    def pixel_height
      height = CHARACTER_HEIGHT / 2.0 + TICK_HEIGHT + TICK_PADDING
      if @label
        height += CHARACTER_HEIGHT / 2.0 + LABEL_TOP_PADDING
      end
      height
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
        x_position = tick_label[:pixel_position] - 1

        label_width = tick_label[:label].to_s.length * CHARACTER_WIDTH
        text_position = x_position - (label_width / 2)
        el = container.add_element(
          'text', 
          {
            'x' => text_position, 
            'y' => TICK_HEIGHT + TICK_PADDING + CHARACTER_HEIGHT / 2.0,
            "class" => "tick-label"
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

      if @label
        el = container.add_element(
          'text',
          {
            'class' => 'axis-label',
            'x' => '50%', 
            'y' => TICK_HEIGHT + TICK_PADDING + CHARACTER_HEIGHT + LABEL_TOP_PADDING, 
            'dx' => -(CHARACTER_WIDTH * @label.length) / 2.0
          }
        )
        el.text = @label
      end

      container
    end
  end
end