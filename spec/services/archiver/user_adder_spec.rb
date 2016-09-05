require 'rails_helper'

RSpec.describe Archiver::UserAdder do
  let(:tweet) { double('Tweet') }
  let(:user) { double('User', twitter_screen_name: 'Beirut') }

  before do
    allow(Tweet)
      .to receive(:where)
      .with(screen_name: user.twitter_screen_name)
      .and_return([tweet])
  end

  subject { described_class.new(user) }

  describe '#add_to_all_tweets' do
    it 'updates tweets matching screen_name with user' do
      expect(tweet).to receive(:update).with(user: user)
      subject.add_to_all_tweets
    end
  end

  describe '#add_to_all_tweet_reviews' do
    let(:tweet_review) { double('TweetReview') }

    before do
      allow(tweet).to receive(:tweet_review).and_return(tweet_review)
    end

    it 'updates tweet reviews tied to tweet matching screen_name with user' do
      expect(tweet_review).to receive(:update).with(user: user)
      subject.add_to_all_tweet_reviews
    end
  end
end
