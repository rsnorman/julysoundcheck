require 'rails_helper'

RSpec.describe Archiver::TweetArchiver do
  describe '#archive' do
    let(:tweet_class) { double('TweetClass') }
    let(:tweet_creator) { double('TweetCreator') }
    let(:jsc_tweet) { double('JSCTweet', tweet_id: '123456789') }
    let(:tweet_client) { double('TweetClient') }
    let(:tweet) { double('Tweet') }

    before do
      allow(tweet_class).to receive(:all).and_return([jsc_tweet])
      allow(TwitterClient).to receive(:instance).and_return(tweet_client)
      allow(tweet_client)
        .to receive(:search)
        .with('#julysoundcheck', since_id: '123456789')
        .and_return([tweet])
      allow(tweet).to receive(:retweet?).and_return(false)
      allow(Archiver::TweetCreator)
        .to receive(:new)
        .with(tweet)
        .and_return(tweet_creator)
    end

    subject { described_class.new(tweet_class.all) }

    it 'creates a tweet' do
      expect(tweet_creator).to receive(:create)
      subject.archive
    end

    context 'with retweet' do
      before { allow(tweet).to receive(:retweet?).and_return(true) }

      it 'doesn\'t create the tweet' do
        expect(tweet_creator).not_to receive(:create)
        subject.archive
      end
    end

    context 'with error' do
      let(:exception) { Class.new(StandardError) }

      before do
        allow(tweet_creator).to receive(:create).and_raise(exception)
        allow(tweet).to receive(:id).and_return SecureRandom.uuid
        allow(tweet).to receive(:text).and_return 'Infinite loop'
      end

      it 'logs error' do
        expect(Rollbar)
          .to receive(:error)
          .with(exception, tweet_id: tweet.id, tweet_text: tweet.text)
        subject.archive
      end
    end
  end
end
