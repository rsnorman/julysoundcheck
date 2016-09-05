require 'rails_helper'

RSpec.describe Archiver::TweetCreator do
  describe '#create' do
    let(:twitter_tweet) { double('TwitterTweet') }
    let(:tweet) { double('Tweet') }
    let(:parser) { double('Parser') }
    let(:feed_item_creator) { double('FeedItemCreator') }
    let(:tweet_user_creator) { double('TweetUserCreator') }

    before do
      allow(parser).to receive(:parse).and_return(text: 'My fav artist')
      allow(FeedItemCreator)
        .to receive(:new)
        .with(tweet)
        .and_return(feed_item_creator)
      allow(Archiver::TweetUserCreator)
        .to receive(:new)
        .with(tweet)
        .and_return(tweet_user_creator)
      allow(Tweet).to receive(:create!).and_return(tweet)
      allow(feed_item_creator).to receive(:create)
      allow(tweet_user_creator).to receive(:create)
    end

    subject { described_class.new(twitter_tweet, parser: parser) }

    it 'creates a tweet' do
      expect(Tweet)
        .to receive(:create!)
        .with(text: 'My fav artist')
        .and_return(tweet)
      subject.create
    end

    it 'creates a feed item' do
      expect(feed_item_creator).to receive(:create)
      subject.create
    end

    it 'creates a user from the tweet' do
      expect(tweet_user_creator).to receive(:create)
      subject.create
    end
  end
end
