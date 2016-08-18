require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe '#signed_in?' do
    before do
      allow(helper).to receive(:twitter_user).and_return(double('user'))
    end

    it 'returns if user is present' do
      expect(helper.signed_in?).to be_truthy
    end
  end

  describe '#current_user' do
    let(:twitter_user) { double('twitter_user', id: SecureRandom.uuid) }
    let(:user) { instance_double('User') }

    before do
      allow(helper).to receive(:twitter_user).and_return(twitter_user)
    end

    before do
      allow(User)
        .to receive(:find_by)
        .with(twitter_id: twitter_user.id)
        .and_return(user)
    end

    it 'returns user that matches twitter id' do
      expect(helper.current_user).to eq user
    end

    context 'with second call' do
      before do
        helper.current_user
      end

      it 'doesn\'t make a second database call' do
        expect(User).to_not receive(:find_by)
        helper.current_user
      end
    end
  end

  describe '#twitter_user' do
    let(:access_token) { SecureRandom.uuid }
    let(:access_token_secret) { SecureRandom.uuid }
    let(:session) do
      {
        'access_token' => access_token,
        'access_token_secret' => access_token_secret
      }
    end

    let(:twitter_client) { double('TwitterClient') }
    let(:twitter_user) { double('TwitterUser') }

    before do
      allow(helper).to receive(:session).and_return(session)

      allow(TwitterClient)
        .to receive(:instance)
        .with(
          access_token: access_token,
          access_token_secret: access_token_secret
        )
        .and_return(twitter_client)

      allow(twitter_client)
        .to receive(:user)
        .with(include_entities: true)
        .and_return(twitter_user)

      allow(Rails)
        .to receive_message_chain('cache.fetch')
        .with("#{access_token}:#{access_token_secret}")
        .and_return(twitter_user)
    end

    it 'returns twitter user' do
      expect(helper.twitter_user).to eq twitter_user
    end

    context 'without access token' do
      let(:access_token) { nil }

      it 'returns nil' do
        expect(helper.twitter_user).to be_nil
      end
    end

    context 'without access token secret' do
      let(:access_token_secret) { nil }

      it 'returns nil' do
        expect(helper.twitter_user).to be_nil
      end
    end
  end
end
