require "spec_helper"

module Ploto
  describe NumericAxis do
    let(:axis) { NumericAxis.new(10,60, 100) }

    describe "#pixel_position" do
      it "returns the right pixel position with a 5% padding" do
        expect(axis.pixel_position(10)).to eq (0 / 90) + 5 
        expect(axis.pixel_position(60)).to eq 90 + 5
        expect(axis.pixel_position(35)).to eq (90.0 * (25.0/50.0)) + 5
        expect(axis.pixel_position(21)).to eq (90.0 * (11.0/50.0)) + 5
      end
    end
  end
end