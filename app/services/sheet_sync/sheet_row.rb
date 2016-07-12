module SheetSync
  class SheetRow
    ATTRIBUTE_COLUMNS = {
      artist: 1,
      album: 2,
      genre: 3,
      source: 4,
      tweet: 5,
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
    end

    attr_reader :row_index

    def initialize(worksheet, row_index)
      @worksheet = worksheet
      @row_index = row_index
    end
  end
end
