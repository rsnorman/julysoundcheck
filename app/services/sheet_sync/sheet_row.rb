module SheetSync
  class SheetRow
    ATTRIBUTE_COLUMNS = {
      artist: 1,
      album: 2,
      genre: 3,
      source: 4,
      review: 5,
      reviewer: 6,
      date_reviewed: 7,
      rating: 8,
      aotm: 9,
      recommended_by: 10
    }.freeze

    ATTRIBUTE_COLUMNS.each_pair do |attr, column_index|
      define_method attr do |with_formula: false|
        if with_formula
          @worksheet.formula_value(row_index, column_index)
        else
          @worksheet.value(row_index, column_index)
        end
      end

      define_method "#{attr}=" do |value|
        @worksheet.set_value(row_index, column_index, value)
      end
    end

    alias tweet review

    attr_reader :row_index

    def initialize(worksheet, row_index)
      @worksheet = worksheet
      @row_index = row_index
    end

    def delete
      ATTRIBUTE_COLUMNS.each_pair do |_attr, column_index|
        @worksheet.set_value(row_index, column_index, nil)
      end
    end
  end
end
