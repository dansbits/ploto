module Ploto
  class PointPlot
    TOP_PADDING=10
    BOTTOM_PADDING=20
    LEFT_PADDING=10
    RIGHT_PADDING=10

    def initialize(x, y)
      @canvas_width = 700
      @canvas_height = 400
      @x = x
      @y = y
      @y_axis = VerticalAxis.new(@y.min, @y.max, @canvas_height - TOP_PADDING - BOTTOM_PADDING)
      @x_axis = HorizontalAxis.new(@x.min, @x.max, @canvas_width - LEFT_PADDING - RIGHT_PADDING - @y_axis.pixel_width)
    end

    def to_s
      plot = REXML::Document.new
      svg = plot.add_element(
        'svg', 
        { 
          'width' => @canvas_width, 
          'height' => @canvas_height, 
          'style' => 'font-family: Monaco, Courier, monospace',
          "shape-rendering"=>"crispEdges" 
        }
      )

      svg.add_element(@y_axis.render)
      svg.add_element(@x_axis.render(@y_axis.pixel_width + LEFT_PADDING, @y_axis.pixel_height + TOP_PADDING))
      add_points(svg)

      output = ''
      plot.write(output)
      output
    end

    def add_points(svg)
      @x.each_with_index do |value, index|
        svg.add_element(
          'circle',
          'cx' => LEFT_PADDING + @y_axis.pixel_width + @x_axis.pixel_position(value), 
          'r'=>"3",
          'cy' => @canvas_height - BOTTOM_PADDING - @y_axis.pixel_position(@y[index]),
          'fill' => '#6CD4FF' 
        )
      end
    end

  end
end