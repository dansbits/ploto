require "spec_helper"

module Ploto
  describe BarPlot do
    describe "#render" do
      let(:x) { ['x','y','z'] }
      let(:y) { [5,6,7] }

      let(:plot) { BarPlot.new(x,y) }

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
        expect(root.get_elements("//svg[@class='plot-area']/rect").length).to eq 3
      end

      it "renders a rect element for each category" do
      end

      context "when there are missing values" do
        let(:x) { [1, nil, 3, nil, 4, 5] }
        let(:y) { [1,2,3,4,5,6]}

        it "does not render the points with missing data and warns the user" do
          xml_string = plot.render
          xml = REXML::Document.new(xml_string)
          expect(xml.get_elements("//svg[@class='plot-area']/rect").length).to eq 4
        end
      end
    end
  end
end