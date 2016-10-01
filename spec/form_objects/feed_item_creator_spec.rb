require 'rails_helper'

RSpec.describe FeedItemCreator do
  describe '#create' do
    let(:feed_item_type) { nil }

    subject { described_class.new(feedable, feed_item_type) }

    context 'for review' do
      let(:feed_item_type) { 'review' }
      let(:review) { double('Review', reviewed_at: Time.current, user: :me) }
      let(:feedable) { review }

      it 'creates a review feed item' do
        expect(FeedItem)
          .to receive(:create)
          .with(feedable: review,
                created_at: review.reviewed_at,
                user: review.user)

        subject.create
      end
    end

    context 'for tweet review' do
      let(:tweet) do
        double('Tweet', tweeted_at: Time.current - 1.day, reply: reply)
      end
      let(:reply) { nil }
      let(:tweet_review) do
        double('TweetReview', tweet: tweet, user: :me, class: 'TweetReview')
      end
      let(:feed_item) { double('FeedItem') }
      let(:feedable) { tweet_review }

      before do
        allow(tweet).to receive(:reply).and_return(reply)
        allow(FeedItem)
          .to receive(:find_by)
          .with(feedable: tweet)
          .and_return(nil)
        allow(FeedItem)
          .to receive(:find_by)
          .with(feedable: reply)
          .and_return(nil)
      end

      context 'with feed item existing for tweet' do
        before do
          allow(FeedItem)
            .to receive(:find_by)
            .with(feedable: tweet)
            .and_return(feed_item)
        end

        it 'updates feed item with tweet review' do
          expect(feed_item).to receive(:update).with(feedable: tweet_review)
          subject.create
        end
      end

      context 'with feed item existing for tweet review' do
        let(:reply) { double('Tweet', tweeted_at: Time.current) }

        before do
          allow(FeedItem)
            .to receive(:find_by)
            .with(feedable: tweet)
            .and_return(nil)
          allow(FeedItem)
            .to receive(:find_by)
            .with(feedable: reply)
            .and_return(feed_item)
        end

        it 'updates feed item with tweet review' do
          expect(feed_item).to receive(:update).with(feedable: tweet_review)
          subject.create
        end
      end

      context 'without existing feed item and reply tweet' do
        it 'creates a tweet review feed item' do
          expect(FeedItem)
            .to receive(:create)
            .with(feedable: tweet_review,
                  created_at: tweet.tweeted_at,
                  user: tweet_review.user)
          subject.create
        end
      end

      context 'without existing feed item and with reply tweet' do
        let(:reply) { double('Tweet', tweeted_at: Time.current) }

        it 'creates a tweet review feed item' do
          expect(FeedItem)
            .to receive(:create)
            .with(feedable: tweet_review,
                  created_at: reply.tweeted_at,
                  user: tweet_review.user)
          subject.create
        end
      end
    end

    context 'for tweet' do
      let(:tweet) do
        double('Tweet', tweeted_at: Time.current - 1.day,
                        reply?: false,
                        class: 'Tweet',
                        user: :me)
      end
      let(:feedable) { tweet }

      context 'with tweet not as reply' do
        it 'creates tweet feed item' do
          expect(FeedItem)
            .to receive(:create)
            .with(feedable: tweet,
                  created_at: tweet.tweeted_at,
                  user: tweet.user)
          subject.create
        end
      end

      context 'with tweet as reply' do
        let(:feed_item) { double('FeedItem') }
        let(:parent_tweet) { double('Tweet') }

        before do
          allow(tweet).to receive(:reply?).and_return(true)
          allow(tweet).to receive(:in_reply_to_tweet).and_return(parent_tweet)
          allow(FeedItem)
            .to receive(:find_by)
            .with(feedable: parent_tweet)
            .and_return(feed_item)
        end

        it 'updates the created_at of the feed item for replied to tweet' do
          expect(feed_item)
            .to receive(:update)
            .with(created_at: tweet.tweeted_at)
          subject.create
        end
      end
    end
  end
end
