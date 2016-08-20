require 'rails_helper'

RSpec.describe FeedItemsHelper do
  let(:feedable) { double('Feedable') }
  let(:type) { 'Tweet' }
  let(:feed_item) do
    double(FeedItem, feedable_type: type, feedable: feedable)
  end

  describe '#feed_item_partial' do
    it 'returns partial path' do
      expect(helper.feed_item_partial(feed_item))
        .to eq '/feed_items/tweet_item'
    end

    context 'with tweet review with tweet' do
      let(:type) { 'TweetReview' }

      before do
        allow(feedable).to receive(:tweet).and_return double('Tweet')
      end

      it 'returns partial path tweet review' do
        expect(helper.feed_item_partial(feed_item))
          .to eq '/feed_items/tweet_review_item'
      end
    end

    context 'with tweet review without tweet' do
      let(:type) { 'TweetReview' }

      before do
        allow(feedable).to receive(:tweet).and_return nil
      end

      it 'returns partial path for review' do
        expect(helper.feed_item_partial(feed_item))
          .to eq '/feed_items/review_item'
      end
    end
  end

  describe '#feed_item_locals' do
    let(:presenter) { double('presenter') }

    before do
      allow(presenter_class).to receive(:new).and_return presenter
    end

    context 'for Tweet' do
      let(:presenter_class) { JulySoundcheckTweet }

      before do
        allow(helper).to receive(:feedable_type).and_return('Tweet')
      end

     it 'returns tweet key with presenter value' do
        expect(helper.feed_item_locals(feed_item)).to eq(tweet: presenter)
      end
    end

    context 'for Review' do
      let(:presenter_class) { JulySoundcheckReview }

      before do
        allow(helper).to receive(:feedable_type).and_return('Review')
      end

     it 'returns tweet key with presenter value' do
        expect(helper.feed_item_locals(feed_item)).to eq(review: presenter)
      end
    end

    context 'for TweetReview' do
      let(:presenter_class) { JulySoundcheckTweetReview }

      before do
        allow(helper).to receive(:feedable_type).and_return('TweetReview')
      end

     it 'returns tweet key with presenter value' do
        expect(helper.feed_item_locals(feed_item))
          .to eq(tweet_review: presenter)
      end
    end
  end
end
