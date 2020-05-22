require_relative "numeric_axis"

module Ploto
  class PointPlot
    TOP_PADDING=10
    BOTTOM_PADDING=20
    LEFT_PADDING=50
    RIGHT_PADDING=10

    def initialize(x, y)
      @canvas_width = 500
      @canvas_height = 300
      @x = x
      @y = y
      @x_axis = NumericAxis.new(@x.min, @x.max, @canvas_width - LEFT_PADDING - RIGHT_PADDING)
      @y_axis = NumericAxis.new(@y.min, @y.max, @canvas_height - TOP_PADDING - BOTTOM_PADDING)
    end

    def to_s
      plot = REXML::Document.new
      svg = plot.add_element('svg', { 'width' => @canvas_width, 'height' => @canvas_height, 'style' => 'font-family: Monaco, Courier, monospace', "shape-rendering"=>"crispEdges" })

      build_x_axis(svg)
      build_y_axis(svg)
      add_points(svg)

      output = ''
      plot.write(output)
      output
    end

    def add_points(svg)
      @x.each_with_index do |value, index|
        svg.add_element(
          'circle',
          'cx' => LEFT_PADDING + @x_axis.pixel_position(value), 
          'r'=>"3",
          'cy' => @canvas_height - BOTTOM_PADDING - @y_axis.pixel_position(@y[index]),
          'fill' => '#6CD4FF' 
        )
      end
    end

    def build_x_axis(svg)
      svg.add_element(
        'line', 
        {

          'style' => "stroke: #000000;",
          "stroke-width" => "1", 
          'x1' => LEFT_PADDING, 
          'y1' => TOP_PADDING,
          'x2' => LEFT_PADDING,
          'y2' => @canvas_height - BOTTOM_PADDING
        }
      )

      @x_axis.labels.each do |label|
        x_position = LEFT_PADDING + label[:pixel_position]
        characters = label[:label].to_s.length
        el = svg.add_element('text', 'x' => x_position - (characters * 5), 'y' => x_labels_y_position)
        el.text = label[:label]
        svg.add_element('line', 'style' => "stroke: #000000; stroke-width: 1px;", 'x1' => x_position, 'y1' => @canvas_height - BOTTOM_PADDING, 'x2' => x_position, 'y2' => @canvas_height - BOTTOM_PADDING + 3 )
      end
    end

    def build_y_axis(svg)
      svg.add_element(
        'line',
        {
          'style' => "stroke: #000000;",
          'stroke-width' => "1",
          'x1' => LEFT_PADDING,
          'y1' => @canvas_height - BOTTOM_PADDING,
          'x2' => @canvas_width - RIGHT_PADDING,
          'y2' => @canvas_height - BOTTOM_PADDING
        }
      )
      @y_axis.labels.each do |label|
        y_position = @canvas_height - BOTTOM_PADDING - label[:pixel_position]
        el = svg.add_element('text', 'x' => LEFT_PADDING - label[:label].to_s.length * 10 - 5, 'y' =>y_position + 5)
        el.text = label[:label]
        svg.add_element('line', 'style' => "stroke: #000000; stroke-width: 1px;", 'x1' => LEFT_PADDING, 'y1' => y_position, 'x2' => LEFT_PADDING - 3, 'y2' => y_position )
      end
    end

    def x_labels_y_position
      @canvas_height - BOTTOM_PADDING + 15
    end
  end
end