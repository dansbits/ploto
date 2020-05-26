module Ploto
  class HorizontalAxis
    def initialize(min_value, max_value, pixel_width)
      @min_value = min_value
      @max_value = max_value
      @pixel_width = pixel_width
      @plottable_pixels = pixel_width * 0.94
      @padding = pixel_width * 0.03
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

    def render(x,y)
      container = REXML::Element.new 'svg'
      container.add_attributes({'x' => x, 'y' => y, 'width' => @pixel_width, 'height' => 20, 'overflow' => 'visible'})
      container.add_element(
        'line', 
        {
          "style" => "stroke: #000000;",
          "stroke-width" => "1",
          "x1" => 0,
          "y1" => 0,
          "x2" => @pixel_width,
          "y2" => 0
        }
      )

      labels.each do |label|
        label_width = label[:label].to_s.length * 9.9055 # approximate pixels per character
        x_position = label[:pixel_position] - (label_width / 2)
        el = container.add_element('text', 'x' => x_position, 'y' => 15)
        el.text = label[:label]
        container.add_element(
          'line', 
          {
            'style' => "stroke: #000000; stroke-width: 1px;",
            'x1' => label[:pixel_position],
            'y1' => 0,
            'x2' => label[:pixel_position],
            'y2' => 3
          }
        )
      end

      container
    end
  end
end