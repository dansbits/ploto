require "spec_helper"

module Ploto
  describe Histogram do
    describe "#render" do
      let(:x) { (1..10).map { rand(1..10) } }

      let(:plot) { Histogram.new(x) }

      it "renders an svg with the right attributes" do
        xml_string = plot.render
        xml = REXML::Document.new(xml_string)
        root = xml.root
        expect(root.name).to eq 'svg'
        expect(root[:width]).to eq '700'
        expect(root[:height]).to eq '400'
        expect(root[:style]).to eq 'font-family: Monaco, Courier, monospace'
        expect(root['shape-rendering']).to eq 'crispEdges'
      end

      it "renders a vertical axis, horizontal axis, and plot area" do
        xml_string = plot.render
        xml = REXML::Document.new(xml_string)
        root = xml.root
        vaxis = root.get_elements("//svg[@class='vertical-axis']")[0]
        expect(vaxis).to_not eq nil
        expect(vaxis[:x]).to eq PointPlot::LEFT_PADDING.to_s
        expect(vaxis[:y]).to eq PointPlot::TOP_PADDING.to_s
        expect(root.get_elements("//svg[@class='horizontal-axis']").length).to eq 1
        expect(root.get_elements("//svg[@class='plot-area']").length).to eq 1
        expect(root.get_elements("//svg[@class='plot-area']/rect").length).to eq Math.sqrt(x.length).ceil
      end
    end
  end
end