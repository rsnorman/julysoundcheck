require 'spec_helper'
require './app/services/sheet_sync/download/tweet_review_downloader'
require './app/services/sheet_sync/download/reviewer_finder'

RSpec.describe SheetSync::Download::TweetReviewDownloader do
  describe '#download' do
    let(:review_syncer_class) do
      double('ReviewSyncerClass').tap do |rsc|
        allow(rsc)
          .to receive(:new)
          .with(type: :tweet_review, reviewer_finder: reviewer_finder)
          .and_return(review_syncer)
      end
    end
    let(:review_syncer) { double('ReviewSyncer') }
    let(:row_parser_class) do
      double('RowParserClass').tap do |rpc|
        allow(rpc)
          .to receive(:new)
          .with(row, review_tweet: review_tweet)
          .and_return(row_parser)
      end
    end
    let(:row_parser) { double('RowParser', parse: review_attrs) }
    let(:sync_policy_class) do
      double('SyncPolicyClass').tap do |spc|
        allow(spc)
          .to receive(:new)
          .with(review_tweet, review_attrs)
          .and_return(sync_policy)
      end
    end
    let(:sync_policy) { double('SyncPolicy', sync?: sync) }
    let(:sync) { true }
    let(:review_tweet_finder_class) do
      double('ReviewTweetFinderClass').tap do |rtfc|
        allow(rtfc)
          .to receive(:new)
          .with(row)
          .and_return(review_tweet_finder)
      end
    end
    let(:review_tweet_finder) { double('ReviewTweetFinder', find: review_tweet) }
    let(:reviewer_finder) { double('ReviwerFinder') }
    let(:reviewer_finder_class) do
      double('ReviewerFinderClass').tap do |rfc|
        allow(rfc).to receive(:new).with(row).and_return(reviewer_finder)
      end
    end

    let(:review_tweet) { double('ReviewTweet') }
    let(:row) { double('SheetRow') }
    let(:review_attrs) { Hash[:artist, 'WU LYF'] }

    subject do
      described_class.new(row, row_parser: row_parser_class,
                               review_syncer: review_syncer_class,
                               sync_policy: sync_policy_class,
                               review_tweet_finder: review_tweet_finder_class,
                               reviewer_finder: reviewer_finder_class)
    end

    it 'syncs review' do
      expect(review_syncer).to receive(:sync).with(artist: 'WU LYF')
      subject.download
    end

    context 'with sync not needed' do
      let(:sync) { false }

      it 'doesn\'t sync the review' do
        expect(review_syncer).not_to receive(:sync)
        subject.download
      end
    end
  end
end
