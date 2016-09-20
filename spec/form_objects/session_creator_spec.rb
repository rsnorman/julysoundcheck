require 'rails_helper'

RSpec.describe SessionCreator do
  describe '#create' do
    let(:twitter_user) do
      double('TwitterUser', id: SecureRandom.uuid,
                            name: 'Bob',
                            screen_name: 'TheBob')
    end

    let(:user) { double('User', sign_ins: 1) }

    subject do
      described_class.new(twitter_user)
    end

    before do
      allow(Time).to receive(:current).and_return(Time.current)
      allow(User)
        .to receive(:find_by)
        .with(twitter_id: twitter_user.id)
        .and_return(user)
      allow(user).to receive(:update)
    end

    it 'updates the user sign in attributes' do
      expect(user)
        .to receive(:update)
        .with(last_sign_in: Time.current, sign_ins: user.sign_ins + 1)
      subject.create
    end

    it 'returns the signed in user 'do
      expect(subject.create).to eq user
    end

    context 'with user not created' do
      before do
        allow(User)
          .to receive(:find_by)
          .with(twitter_id: twitter_user.id)
          .and_return(nil)
        allow(User).to receive(:create).and_return(user)
      end

      it 'creates user from twitter user' do
        expect(User)
          .to receive(:create)
          .with(twitter_id: twitter_user.id,
                twitter_name: twitter_user.name,
                twitter_screen_name: twitter_user.screen_name)
          .and_return(user)
        subject.create
      end
    end
  end
end
