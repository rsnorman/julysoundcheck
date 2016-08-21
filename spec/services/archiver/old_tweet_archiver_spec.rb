require 'rails_helper'

RSpec.describe Archiver::OldTweetArchiver do
  describe '#archive' do
    let(:twitter_client) { double('TwitterClient') }
    let(:tweet) { double('Tweet') }
    let(:parser) { double('Parser') }
    let(:feed_item_creator) { double('FeedItemCreator') }
    let(:tweet_user_creator) { double('TweetUserCreator') }
    let(:jsc_tweet) { double('JSCTweet') }
    let(:saved_tweets) { double('SavedTweets') }

    subject do
      described_class.new(archived_tweets: saved_tweets, parser: parser)
    end

    before do
      allow(File)
        .to receive(:read)
        .with(described_class::DEFAULT_TWEETS_FILEPATH)
        .and_return('1234')
      allow(TwitterClient).to receive(:instance).and_return(twitter_client)
      allow(twitter_client)
        .to receive(:statuses)
        .with([1234])
        .and_return([tweet])
      allow(Tweet)
        .to receive(:create)
        .with(text: 'Great album!')
        .and_return(jsc_tweet)
      allow(parser)
        .to receive(:parse)
        .with(tweet)
        .and_return(text: 'Great album!')
      allow(FeedItemCreator)
        .to receive(:new)
        .with(jsc_tweet)
        .and_return(feed_item_creator)
      allow(feed_item_creator).to receive(:create)
      allow(Archiver::TweetUserCreator)
        .to receive(:new)
        .with([jsc_tweet])
        .and_return(tweet_user_creator)
      allow(tweet_user_creator).to receive(:create)
      allow(saved_tweets).to receive(:pluck).with(:tweet_id).and_return []
    end

    it 'creates archived tweet' do
      expect(Tweet).to receive(:create).with(text: 'Great album!')
      subject.archive
    end

    it 'creates feed item' do
      expect(feed_item_creator).to receive(:create)
      subject.archive
    end

    it 'creates user from new tweets' do
      expect(tweet_user_creator).to receive(:create)
      subject.archive
    end

    context 'with tweet already saved' do
      before do
        allow(saved_tweets)
          .to receive(:pluck)
          .with(:tweet_id)
          .and_return ['1234']
        allow(twitter_client)
          .to receive(:statuses)
          .with([])
          .and_return([])
        allow(Archiver::TweetUserCreator)
          .to receive(:new)
          .with([])
          .and_return(tweet_user_creator)
      end

      it 'does not recreate the tweet' do
        expect(Tweet).not_to receive(:create)
        subject.archive
      end
    end
  end
end
