require_relative "./bar/plot_area"

module Ploto
  class BarPlot
    TOP_PADDING=10
    BOTTOM_PADDING=20
    LEFT_PADDING=10
    RIGHT_PADDING=10

    attr_accessor :x_label, :y_label

    def initialize(x, y)
      @canvas_width = 700
      @canvas_height = 400
      @x = x
      @y = y
    end

    def render
      x_axis = initialize_x_axis(@x)
      y_axis = VerticalAxis.new(@y.compact.min, @y.compact.max, pixel_height: @canvas_height - TOP_PADDING - BOTTOM_PADDING - x_axis.pixel_height, label: y_label)
      x_axis.pixel_width = @canvas_width - LEFT_PADDING - RIGHT_PADDING - y_axis.pixel_width

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

      svg.add_element(y_axis.render)
      svg.add_element(x_axis.render(y_axis.pixel_width + LEFT_PADDING, TOP_PADDING + y_axis.pixel_height))
      plot_area = Bar::PlotArea.new(x_axis, y_axis)
      svg.add_element(plot_area.render(LEFT_PADDING + y_axis.pixel_width, TOP_PADDING, @x, @y))

      output = ''
      plot.write(output)
      output
    end

    def initialize_x_axis(x)
      Axes::CategoricalHorizontalAxis.new(@x.compact.uniq, label: x_label)
    end

    def to_iruby
      ["text/html", render]
    end

  end
end