require 'rails_helper'

RSpec.describe SheetSync::Download::ReviewDownloader do
  describe '#download' do
    let(:user) { double('User', tweet_reviews: tweet_reviews) }
    let(:row) { double('Row') }
    let(:tweet_reviews) { double('TweetReview') }
    let(:row_parser_class) { double('RowParserClass') }
    let(:row_parser) { double('RowParser', parse: row_attrs) }
    let(:review_syncer_class) { double('ReviewSyncerClass') }
    let(:review_syncer) { double('ReviewSyncer') }
    let(:row_attrs) { Hash[artist: 'Cursive', album: 'Domestica'] }

    before do
      allow(review_syncer_class)
        .to receive(:new)
        .with(type: :review)
        .and_return(review_syncer)
      allow(row_parser_class).to receive(:new).with(row).and_return(row_parser)
    end

    subject do
      described_class.new(row, row_parser: row_parser_class,
                               review_syncer: review_syncer_class)
    end

    it 'creates a new review' do
      expect(review_syncer).to receive(:sync).with(row_attrs)
      subject.download
    end
  end
end
