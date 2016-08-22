require 'rails_helper'

RSpec.describe Archiver::TweetUpdater do
  describe '#update' do
    let(:tweet) { double('Tweet', tweet_id: '123') }
    let(:tweets) { [tweet] }
    let(:parser) { double('Parser') }
    let(:twitter_client) { double('TwitterClient') }
    let(:twitter_tweet) { double('TwitterTweet', id: 123) }

    subject { described_class.new(tweets, parser) }

    before do
      allow(tweets).to receive(:pluck).and_return([tweet.tweet_id])
      allow(parser)
        .to receive(:parse)
        .with(twitter_tweet)
        .and_return(text: 'Put me to sleep')
      allow(TwitterClient).to receive(:instance).and_return(twitter_client)
      allow(twitter_client)
        .to receive(:statuses)
        .with(['123'])
        .and_return([twitter_tweet])
    end

    it 'updates an existing tweet' do
      expect(tweet).to receive(:update).with(text: 'Put me to sleep')
      subject.update
    end
  end
end
