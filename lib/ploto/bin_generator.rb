module Ploto
  class BinGenerator
    attr_accessor :values

    def initialize(values)
      @values = values
    end

    def generate
      min = @values.min
      max = @values.max
      bins = (1..n_bins).map do |bin_number|
        range_start = min + bin_width * (bin_number - 1)
        range_end = min + (bin_width * bin_number)
        if range_end == max
          { range: (range_start..range_end), observations: 0  }
        else
          { range: (range_start...range_end), observations: 0  }
        end
      end

      values.each do |value|
        bin = bins.find { |b| b[:range].cover? value }
        bin[:observations] += 1
      end

      bins
    end

    def n_bins
      @n_bins ||= Math.sqrt(@values.length).ceil
    end

    def bin_width
      @bin_width ||= (@values.max - @values.min).to_f / n_bins.to_f
    end
  end
end