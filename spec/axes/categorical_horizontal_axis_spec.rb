module Ploto
  module Axes
    describe CategoricalHorizontalAxis do
      describe "#render" do
        let(:axis) { CategoricalHorizontalAxis.new(['foo','bar'], pixel_width: 100) }

        it "renders the border line, tick marks, and tick labels" do
          xml = axis.render(50, 100)
          root = xml.root
          expect(root[:width].to_i).to eq 100
          height = (CHARACTER_HEIGHT / 2.0) + 
                    CategoricalHorizontalAxis::TICK_HEIGHT + CategoricalHorizontalAxis::TICK_PADDING
          expect(root[:height].to_i).to eq height
          expect(root.name).to eq 'svg'
          expect(root.get_elements("//line[@class='tick-mark']").length).to eq 2
          expect(root.get_elements("//text[@class='tick-label']").length).to eq 2
          expect(root.get_elements("//line[@class='axis-line']").length).to eq 1

          axis_line = root.get_elements("//line[@class='axis-line']")[0]
          expect(axis_line[:x1]).to eq "0"
          expect(axis_line[:y1]).to eq "0"
          expect(axis_line[:x2]).to eq "100"
          expect(axis_line[:y2]).to eq "0"
        end

        context "with an axis label" do
          before { axis.label = 'Bar' }

          it "renders the label" do
            xml = axis.render(50, 100)
            root = xml.root
            expect(root[:height].to_i).to eq(
              Ploto::CHARACTER_HEIGHT +
              NumericHorizontalAxis::TICK_HEIGHT +
              NumericHorizontalAxis::TICK_PADDING + 
              NumericHorizontalAxis::LABEL_TOP_PADDING
            )
            expect(root.get_elements("//text[@class='axis-label']").length).to eq 1
          end
        end
      end
    end
  end
end