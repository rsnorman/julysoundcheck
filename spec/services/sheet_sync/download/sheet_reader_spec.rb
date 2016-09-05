require 'rails_helper'

RSpec.describe SheetSync::Download::SheetReader do
  describe '#download' do
    let(:row) do
      double('WorksheetRow', artist: 'Nick Cave',
                             album: 'Push The Sky Away',
                             tweet: tweet_review)
    end
    let(:worksheet) do
      double('Worksheet').tap do |w|
        allow(w).to receive(:each_row).and_yield(row)
      end
    end

    subject { described_class.new(worksheet: worksheet) }

    context 'with link to tweet' do
      let(:tweet_review_downloader) { double('TweetReviewDownloader') }
      let(:tweet_review) { '=HYPERLINK("twitter.com/2342")' }

      before do
        allow(SheetSync::Download::TweetReviewDownloader)
          .to receive(:new)
          .with(row)
          .and_return(tweet_review_downloader)
      end

      it 'downloads tweet review' do
        expect(tweet_review_downloader).to receive(:download)
        subject.download
      end
    end

    context 'with no link to tweet' do
      let(:review_downloader) { double('ReviewDownloader') }
      let(:tweet_review) { '' }

      before do
        allow(SheetSync::Download::ReviewDownloader)
          .to receive(:new)
          .with(row)
          .and_return(review_downloader)
      end

      it 'downloads review' do
        expect(review_downloader).to receive(:download)
        subject.download
      end
    end
  end
end
