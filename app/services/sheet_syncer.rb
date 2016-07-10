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

  def initialize(tweet_reviews = TweetReview.all)
    @tweet_reviews = tweet_reviews
    @existing_reviews ||= {}
  end

  def sync
    (2..worksheet.num_rows).each do |row|
      next unless syncable?(row)
      review_attributes = parse_review(row)
      sync_review(review_attributes) if resync_review?(review_attributes)
    end
  end

  def sync_review(review_attributes)
    if (tweet_review = tweet_review_for(review_attributes))
      tweet_review.update(review_attributes)
    else
      TweetReview.create(review_attributes)
    end
  end

  def resync_review?(review_attributes)
    tweet_review = tweet_review_for(review_attributes)
    tweet_review.nil? || tweet_review.rating.value != review_attributes[:rating]
  end

  def tweet_review_for(review_attributes)
    @existing_reviews[review_attributes[:tweet_id]] ||=
      @tweet_reviews.find_by(tweet_id: review_attributes[:tweet_id])
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
      rating: Rating.from_score(worksheet[row, ATTRIBUTE_COLUMNS[:rating]]).value
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
    @session ||= GoogleDrive.saved_session(google_creds_filepath)
  end

  def google_creds_filepath
    unless File.exists?(GOOGLE_DRIVE_CREDS_FILEPATH)
      File.open(GOOGLE_DRIVE_CREDS_FILEPATH, 'wb') do |f|
        f << GOOGLE_DRIVE_CREDS.to_json
      end
    end
    GOOGLE_DRIVE_CREDS_FILEPATH
  end
end
