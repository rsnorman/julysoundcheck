module SheetSync
  class Worksheet
    SHEET_KEY = ENV['GOOGLE_SHEET_KEY'].freeze

    GOOGLE_DRIVE_CREDS_FILEPATH = './config/google_drive.json'.freeze

    GOOGLE_DRIVE_CREDS = {
      "client_id": ENV['GOOGLE_CLIENT_ID'],
      "client_secret": ENV['GOOGLE_CLIENT_SECRET'],
      "scope": [
        "https://www.googleapis.com/auth/drive",
        "https://spreadsheets.google.com/feeds/"
      ],
      "refresh_token": ENV['GOOGLE_REFRESH_TOKEN']
    }

    delegate :save, to: :sheet

    def initialize(sheet_key: SHEET_KEY)
      @sheet_key = sheet_key
    end

    def each_row(&block)
      (2..sheet.num_rows).each_with_index do |row_index, index|
        row = SheetRow.new(self, row_index)
        if block.arity == 1
          block.call(row)
        else
          block.call(row, index)
        end
      end
    end

    def value(row_index, column_index)
      sheet[row_index, column_index]
    end

    def formula_value(row_index, column_index)
      sheet.input_value(row_index, column_index)
    end

    def set_value(row_index, column_index, value)
      sheet[row_index, column_index] = value
    end

    def build_row
      SheetRow.new(self, sheet.num_rows + 1)
    end

    private

    def sheet
      @sheet ||= session.spreadsheet_by_key(@sheet_key).worksheets[0]
    end

    def session
      @session ||= GoogleDrive.saved_session(google_creds_filepath)
    end

    # TODO: Test that file is created successfully, most likely by
    # encapsulating in its own object since this class should know nothing
    # about creating google credential files
    def google_creds_filepath
      unless File.exists?(GOOGLE_DRIVE_CREDS_FILEPATH)
        File.open(GOOGLE_DRIVE_CREDS_FILEPATH, 'wb') do |f|
          f << GOOGLE_DRIVE_CREDS.to_json
        end
      end
      GOOGLE_DRIVE_CREDS_FILEPATH
    end
  end
end
