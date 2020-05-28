module Ploto
  class VerticalAxis

    attr_accessor :pixel_height

    def initialize(min_value, max_value, pixel_height)
      @min_value = min_value
      @max_value = max_value
      @pixel_height = pixel_height
      @plottable_pixels = pixel_height * 0.94
      @padding = @pixel_height * 0.03
    end

    def pixel_width
      labels.map { |label| label[:label].to_s.length }.max * 10 + 3
    end

    def pixel_position(value)
      pct_range = (value - @min_value).to_f / (@max_value - @min_value).to_f
      (@plottable_pixels.to_f * pct_range) + @padding
    end

    def render
      container = REXML::Element.new 'svg'
      container.add_attributes({'x' => 10, 'y' => 10, 'width' => pixel_width, 'height' => @pixel_height, 'overflow' => 'visible'})
      container.add_element(
        'line', 
        {
          "style" => "stroke: #000000;",
          "stroke-width" => "1",
          "x1" => pixel_width,
          "y1" => 0,
          "x2" => pixel_width,
          "y2" => @pixel_height
        }
      )
      labels.each do |label|
        y_position = @pixel_height - label[:pixel_position]
        el = container.add_element('text', 'x' => 0, 'y' => y_position + 5)
        el.text = label[:label]
        container.add_element(
          'line', 
          {
            'style' => "stroke: #000000; stroke-width: 1px;",
            'x1' => pixel_width,
            'y1' => y_position,
            'x2' => pixel_width - 3,
            'y2' => y_position
          }
        )
      end
      container
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