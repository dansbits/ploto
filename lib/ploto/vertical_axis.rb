module Ploto
  class VerticalAxis

    attr_accessor :label
    attr_reader :pixel_height

    CHARACTER_WIDTH = 9.9055
    CHARACTER_HEIGHT = 18.0
    TICK_WIDTH = 3
    LABEL_WIDTH = CHARACTER_HEIGHT
    LABEL_PADDING = 12

    def initialize(min_value, max_value, label: nil, pixel_height: nil)
      @min_value = min_value
      @max_value = max_value
      @label = label
      self.pixel_height = pixel_height if pixel_height
    end

    def pixel_width
      width = labels.map { |label| label[:label].to_s.length }.max * CHARACTER_WIDTH + TICK_WIDTH

      width += LABEL_WIDTH + LABEL_PADDING if label

      width
    end

    def pixel_height=(pixels)
      @pixel_height = pixels
      @plottable_pixels = pixels * 0.94
      @padding = @pixel_height * 0.03
    end

    def pixel_position(value)
      pct_range = (value - @min_value).to_f / (@max_value - @min_value).to_f
      (@plottable_pixels.to_f * pct_range) + @padding
    end

    def render
      container = REXML::Element.new 'svg'
      container.add_attributes(
        {
          'x' => 10,
          'y' => 10,
          'width' => pixel_width,
          'height' => pixel_height,
          'overflow' => 'visible',
          'class' => 'vertical-axis'
        }
      )

      container.add_element(
        'line', 
        {
          "class" => "axis-line",
          "style" => "stroke: #000000;",
          "stroke-width" => "1",
          "x1" => pixel_width,
          "y1" => 0,
          "x2" => pixel_width,
          "y2" => @pixel_height
        }
      )
      
      axis_label_offset = self.label ? CHARACTER_HEIGHT + LABEL_PADDING : 0
      
      labels.each do |tick_label|
        y_position = @pixel_height - tick_label[:pixel_position]
        el = container.add_element('text', "class" => "tick-label", 'x' => axis_label_offset, 'y' => y_position + 5)
        el.text = tick_label[:label]
        container.add_element(
          'line', 
          {
            'class' => "tick-mark",
            'style' => "stroke: #000000; stroke-width: 1px;",
            'x1' => pixel_width,
            'y1' => y_position,
            'x2' => pixel_width - 3,
            'y2' => y_position
          }
        )
      end

      if self.label
        container.add_element(axis_label)
      end

      container
    end

    def axis_label
      pixel_length = label.length * CHARACTER_WIDTH
      x = CHARACTER_HEIGHT
      y = (@pixel_height / 2.0) + (pixel_length / 2.0)

      lbl = REXML::Element.new('text')
      lbl.text = label
      lbl.add_attributes(
        {
          "class" => "axis-label", 
          'x' => x, 
          'y' => y,
          'transform' => "rotate(-90,#{x},#{y})"
        }
      )
      lbl
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