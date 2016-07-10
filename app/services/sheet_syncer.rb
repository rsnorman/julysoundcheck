require 'google_drive'

class SheetSyncer
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

  SHEET_KEY = '1mKhox0CVtxfyzYG_vqDe7wD6EaX0oS6lyZpjVBR9cDk'.freeze

  GOOGLE_DRIVE_CREDS_FILEPATH = './config/google_drive.json'.freeze

  def sync(tweet_reviews = TweetReview.all)
    (2..worksheet.num_rows).each do |row|
      next unless syncable?(row)
      review_attributes = parse_review(row)
      next if tweet_reviews.exists?(tweet_id: review_attributes[:tweet_id])
      TweetReview.create(review_attributes)
    end
  end

  def syncable?(row)
    worksheet.input_value(row, ATTRIBUTE_COLUMNS[:tweet]).starts_with?('=HYPERLINK')
  end

  def parse_review(row)
    {
      artist: worksheet[row, ATTRIBUTE_COLUMNS[:artist]],
      album: worksheet[row, ATTRIBUTE_COLUMNS[:album]],
      listen_url: parse_link(worksheet.input_value(row, ATTRIBUTE_COLUMNS[:source])),
      tweet_id: parse_tweet_id(worksheet.input_value(row, ATTRIBUTE_COLUMNS[:tweet])),
      rating: worksheet[row, ATTRIBUTE_COLUMNS[:rating]]
    }
  end

  def parse_link(cell_formula)
    cell_formula.split('"').second
  end

  def parse_tweet_id(cell_formula)
    parse_link(cell_formula).split('/').last
  end

  def worksheet
    @worksheet ||= session.spreadsheet_by_key(SHEET_KEY).worksheets[0]
  end

  def session
    @session ||= GoogleDrive.saved_session(GOOGLE_DRIVE_CREDS_FILEPATH)
  end
end
