require "spec_helper"
require_relative "../lib/ploto/bin_generator"

module Ploto
  describe BinGenerator do
    describe "#n_bins" do
      let(:data) { (1..100).map { rand(1..100) } }
      let(:generator) { BinGenerator.new(data) }

      it "calculates the correct number of bins" do
        expect(generator.n_bins).to eq Math.sqrt(data.length)
      end

      context "when the square root of the number of observations is not an integer" do
        let(:data) { (1..33).map { rand(1..100) } }
        it "rounds up to the nearest integer" do
          expect(generator.n_bins).to eq Math.sqrt(data.length).ceil
        end
      end
    end

    describe "#bin_width" do
      let(:data) { [1,2,3,4,5,4,3,2,1,2] }

      let(:generator) { BinGenerator.new(data) }

      it "calculates the width of one bin" do
        n_bins = generator.n_bins
        width = (data.max - data.min).to_f / n_bins.to_f
        expect(generator.bin_width).to eq width
      end
    end

    describe "#generate" do
      let(:data) { [1,2,3,4,5,4,3,2,1,2] }

      let(:generator) { BinGenerator.new(data) }

      it "generates bins with the right min,max, and n_observations" do
        bins = generator.generate
        expect(bins.length).to eq 4
        expect(bins[0][:range].begin).to eq 1.0
        expect(bins[0][:range].end).to eq 2.0
        expect(bins[0][:observations]).to eq 2
        expect(bins[0][:range].exclude_end?).to eq true

        expect(bins[1][:range].begin).to eq 2.0
        expect(bins[1][:range].end).to eq 3.0
        expect(bins[1][:observations]).to eq 3
        expect(bins[1][:range].exclude_end?).to eq true

        expect(bins[3][:range].begin).to eq 4.0
        expect(bins[3][:range].end).to eq 5.0
        expect(bins[3][:observations]).to eq 3
        # We must include the end of the range for the last bin because otherwise
        # the max value in the data would not be within the plot range
        expect(bins[3][:range].exclude_end?).to eq false
      end
    end
  end
end