require 'rails_helper'

RSpec.describe SheetSync::Download::ReviewTweetFinder do
  describe '#find' do
    let(:row) do
      double('SheetRow').tap do |sr|
        allow(sr)
          .to receive(:tweet)
          .with(with_formula: true)
          .and_return(
            '=HYPERLINK("https://twitter.com/rnorman/status/123456789"' \
            ',"Deadpan and honest sad indie")'
          )
      end
    end
    let(:tweet_creator_class) do
      double('TweetCreatorClass').tap do |tcc|
        allow(tcc)
          .to receive(:new)
          .with(twitter_tweet)
          .and_return(tweet_creator)
      end
    end
    let(:tweet_creator) { double('TweetCreator', create: new_tweet) }
    let(:new_tweet) { double('NewTweet') }
    let(:existing_tweet) { double('Tweet') }
    let(:twitter_client) { double('TwitterClient') }
    let(:twitter_tweet) { double('TwitterTweet') }

    before do
      allow(Tweet)
        .to receive(:find_by)
        .with(tweet_id: '123456789')
        .and_return(existing_tweet)
    end

    subject do
      described_class.new(row, tweet_creator: tweet_creator_class,
                               twitter_client: twitter_client)
    end

    it 'returns tweet matching ID in tweet link' do
      expect(subject.find).to eq existing_tweet
    end

    context 'with tweet not created yet' do
      before do
        allow(Tweet)
          .to receive(:find_by)
          .with(tweet_id: '123456789')
          .and_return(nil)
        allow(twitter_client)
          .to receive(:status)
          .with('123456789')
          .and_return(twitter_tweet)
      end

      it 'creates the tweet' do
        expect(tweet_creator).to receive(:create)
        subject.find
      end
    end
  end
end
