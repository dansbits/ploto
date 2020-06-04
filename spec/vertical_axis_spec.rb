require "spec_helper"

module Ploto
  describe VerticalAxis do
    describe "#pixel_width" do
      let(:axis) { VerticalAxis.new(0, 5, pixel_height: 100) }
      context "with no label" do
        it "calculates enough space for tick marks and labels" do
          expect_characters = 3
          expect(axis.pixel_width).to eq (VerticalAxis::CHARACTER_WIDTH * expect_characters) + VerticalAxis::TICK_WIDTH
        end
      end

      context "with an axis label" do
        before { axis.label = "Foo" }

        it "calculates enough space for tick marks, tick labels, and axis label" do
          expect_characters = 3
          expected_width = (VerticalAxis::CHARACTER_WIDTH * expect_characters) + VerticalAxis::LABEL_PADDING + 
                           VerticalAxis::TICK_WIDTH + VerticalAxis::LABEL_WIDTH
          expect(axis.pixel_width).to eq (expected_width)
        end
      end
    end

    describe "#render" do
      let(:axis) { VerticalAxis.new(0, 5, pixel_height: 100) }

      it "renders an SVG with axis line tick marks, and tick labels" do
        xml = axis.render
        root = xml.root
        expect(root.name).to eq 'svg'
        expect(root[:x]).to eq '10'
        expect(root[:y]).to eq '10'
        expect(root[:height]).to eq '100'

        # The longest tick label should be three characters, so we expect the width of the vertical
        # axis to be 3 characters wide, plus additional width for the axis ticks
        expected_width = (VerticalAxis::CHARACTER_WIDTH * 3) + VerticalAxis::TICK_WIDTH

        expect(root[:width]).to eq expected_width.to_s
        expect(root.get_elements("//line[@class='axis-line']").length).to eq 1
        expect(root.get_elements("//line[@class='tick-mark']").length).to eq 5
        expect(root.get_elements("//text[@class='tick-label']").length).to eq 5
      end

      context "with an axis label" do
        before { axis.label = 'Foo' }

        it "renders the label and offsets the other elements" do
          xml = axis.render
          root = xml.root

          expect(root.get_elements("//text[@class='axis-label']").length).to eq 1
          label = root.get_elements("//text[@class='axis-label']")[0]
          expect(label.text).to eq 'Foo'
          tick_label = root.get_elements("//text[@class='tick-label']")[0]
          expect(tick_label[:x].to_f).to eq VerticalAxis::CHARACTER_HEIGHT + VerticalAxis::LABEL_PADDING
        end
      end
    end
  end
end