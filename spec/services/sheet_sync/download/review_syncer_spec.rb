require 'rails_helper'

RSpec.describe SheetSync::Download::ReviewSyncer do
  describe '#sync' do
    let(:review_attrs) do
      {
        artist: 'Devendra Barnhart',
        album: 'Mala',
        genre: 'Indie'
      }
    end
    let(:user) { double('User', tweet_reviews: tweet_reviews) }
    let(:tweet_reviews) { double('TweetReviews', create!: nil) }
    let(:reviewer_finder) { double('ReviewerFinder', find: user) }
    let(:feed_item_creator_class) { double('FeedItemCreatorClass') }
    let(:feed_item_creator) { double('FeedItemCreator', create: nil) }

    before do
      allow(tweet_reviews)
        .to receive(:find_by)
        .with(artist: 'Devendra Barnhart', album: 'Mala')
        .and_return(review)
      allow(feed_item_creator_class)
        .to receive(:new)
        .with(review, :tweet_review)
        .and_return(feed_item_creator)
    end

    subject do
      described_class.new(reviewer_finder: reviewer_finder,
                          feed_item_creator: feed_item_creator_class)
    end

    context 'with review existing' do
      let(:review) { double('Review') }

      it 'updates the review' do
        expect(review).to receive(:update!).with(review_attrs)
        subject.sync(review_attrs)
      end
    end

    context 'with review not synced yet' do
      let(:review) { nil }

      it 'creates a review for the user' do
        expect(tweet_reviews).to receive(:create!).with(review_attrs)
        subject.sync(review_attrs)
      end

      it 'creates a feed item' do
        expect(feed_item_creator).to receive(:create)
        subject.sync(review_attrs)
      end
    end
  end
end
