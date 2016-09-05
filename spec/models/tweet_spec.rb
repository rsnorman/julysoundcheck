require 'rails_helper'

RSpec.describe Tweet do
  subject do
    described_class.new(text: 'My first tweet', tweeted_at: Time.current)
  end

  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to(:in_reply_to_tweet).class_name('Tweet') }
  it do
    is_expected
      .to have_one(:reply)
      .with_foreign_key(:in_reply_to_tweet_id)
      .class_name('Tweet')
  end
  it { is_expected.to have_one :tweet_review }

  it { is_expected.to validate_uniqueness_of :tweet_id }

  describe '#reply?' do
    context 'with in_reply_to_tweet' do
      before do
        allow(subject).to receive(:in_reply_to_tweet_id).and_return 1
      end

      it 'returns true' do
        expect(subject).to be_reply
      end
    end

    context 'without in_reply_to_tweet' do
      it 'returns false' do
        expect(subject).not_to be_reply
      end
    end
  end
end
