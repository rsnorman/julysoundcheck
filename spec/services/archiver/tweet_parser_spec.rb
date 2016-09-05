require 'rails_helper'

RSpec.describe Archiver::TweetParser do
  describe '#to_hash' do
    let(:user) { double('User', id: '99') }
    let(:created_at) { Time.current - 1.day }
    let(:tweet) do
      double('Tweet', id: '123456789',
                      text: 'Great stuff!',
                      created_at: created_at,
                      in_reply_to_status_id: '987654321',
                      user: user)
    end
    let(:reply_tweet) { double('Tweet') }

    before do
      allow(Tweet)
        .to receive(:find_by)
        .with(tweet_id: '987654321')
        .and_return(reply_tweet)
      allow(User).to receive(:find_by).with(twitter_id: '99').and_return(:user)
    end

    subject { described_class.new(tweet).to_hash }

    it 'returns tweet ID' do
      expect(subject[:tweet_id]).to eq '123456789'
    end

    it 'returns tweet text' do
      expect(subject[:text]).to eq 'Great stuff!'
    end

    it 'returns time tweet was created at' do
      expect(subject[:tweeted_at]).to eq created_at
    end

    it 'returns status ID of replied to tweet' do
      expect(subject[:in_reply_to_status_id]).to eq '987654321'
    end

    it 'returns tweet that matches ID of replied to tweet' do
      expect(subject[:in_reply_to_tweet]).to eq reply_tweet
    end

    it 'returns user that matches twitter ID' do
      expect(subject[:user]).to eq :user
    end
  end
end
