require 'rails_helper'

RSpec.describe ReviewerFeedItemsHelper do
  let(:user) { double('User', name: 'Scott Weiland') }

  before do
    assign(:user, user)
  end

  describe '#user_name' do
    it 'returns user name' do
      expect(helper.user_name).to eq 'Scott Weiland'
    end

    context 'with user nil' do
      let(:user) { nil }

      before do
        assign(:screen_name, 'scott_weiland')
      end

      it 'returns assigned screen name' do
        expect(helper.user_name).to eq '@scott_weiland'
      end
    end

    context 'with user without name' do
      before do
        allow(user).to receive(:name).and_return(nil)
        allow(user).to receive(:screen_name).and_return('The Scott Weiland')
      end

      it 'returns user screen name' do
        expect(helper.user_name).to eq 'The Scott Weiland'
      end
    end
  end

  describe '#twitter_profile?' do
    context 'with twitter id' do
      before { allow(user).to receive(:twitter_id).and_return(1) }

      it 'returns true' do
        expect(helper.twitter_profile?).to be_truthy
      end
    end

    context 'without twitter id' do
      before { allow(user).to receive(:twitter_id).and_return(nil) }

      it 'returns false' do
        expect(helper.twitter_profile?).to be_falsy
      end
    end

    context 'with no user' do
      let(:user) { nil }

      it 'returns false' do
        expect(helper.twitter_profile?).to be_falsy
      end
    end
  end
end
