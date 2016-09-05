require 'rails_helper'

RSpec.describe Archiver::TweetUserCreator do
  describe '#create' do
    context 'with user existing' do
      let(:user) { double('User') }
      let(:twitter_user) do
        double('TwitterUser', id: SecureRandom.uuid,
                              name: 'Josh Tillman',
                              screen_name: 'PadreJuanMisty',
                              profile_image_uri: 'fjm.jpg')
      end
      let(:client) { double('TwitterClient') }
      let(:twitter_tweet) { double('TwitterTweet', user: twitter_user) }
      let(:tweet) { double('Tweet', tweet_id: SecureRandom.uuid) }

      before do
        allow(TwitterClient).to receive(:instance).and_return(client)
        allow(client)
          .to receive(:status)
          .with(tweet.tweet_id)
          .and_return(twitter_tweet)
        allow(User)
          .to receive(:find_by)
          .with(twitter_id: twitter_user.id)
          .and_return(user)
      end

      subject { described_class.new(tweet) }

      it 'ties the tweet to the user' do
        expect(tweet).to receive(:update).with(user: user)
        subject.create
      end

      context 'with user not created' do
        let(:new_user) { double('NewUser') }

        before do
          allow(User).to receive(:find_by).and_return nil
          allow(User)
            .to receive(:create)
            .with(twitter_name: twitter_user.name,
                  twitter_screen_name: twitter_user.screen_name,
                  twitter_id: twitter_user.id,
                  profile_image_uri: twitter_user.profile_image_uri)
            .and_return(new_user)
        end

        it 'creates a new user and ties to tweet' do
          expect(tweet).to receive(:update).with(user: new_user)
          subject.create
        end
      end
    end
  end
end
