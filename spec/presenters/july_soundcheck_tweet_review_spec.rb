require 'rails_helper'

RSpec.describe JulySoundcheckTweetReview do
  let(:user) { double('User') }
  let(:reply) { nil }
  let(:tweet) { double('Tweet', reply: reply) }
  let(:review) { double('Review', user: user, tweet: tweet) }
  let(:feed_item) { double('FeedItem') }

  subject { described_class.new(review, feed_item) }

  it { is_expected.to delegate_method(:profile_image_uri).to(:user) }
  it { is_expected.to delegate_method(:rating).to(:tweet_review) }
  it { is_expected.to delegate_method(:artist).to(:tweet_review) }
  it { is_expected.to delegate_method(:album).to(:tweet_review) }
  it { is_expected.to delegate_method(:listen_url).to(:tweet_review) }
  it { is_expected.to delegate_method(:genre).to(:tweet_review) }
  it { is_expected.to delegate_method(:album_of_the_month).to(:tweet_review) }
  it { is_expected.to delegate_method(:description).to(:rating).with_prefix }

  describe '#user_name' do
    let(:name) { 'Lockett Pundt' }

    before { allow(user).to receive(:name).and_return name }

    it 'returns user name' do
      expect(subject.user_name).to eq 'Lockett Pundt'
    end

    context 'without a user name' do
      let(:name) { nil }

      before do
        allow(user).to receive(:twitter_name).and_return 'Lockett Pundt Official'
      end

      it 'returns user twitter_name' do
        expect(subject.user_name).to eq 'Lockett Pundt Official'
      end
    end
  end

  describe '#screen_name' do
    before do
      allow(user)
        .to receive(:twitter_screen_name)
        .and_return('the_flea')
    end

    it 'returns user\'s twitter screen name' do
      expect(subject.screen_name).to eq 'the_flea'
    end
  end

  describe 'reviewed_on' do
    before do
      allow(feed_item)
        .to receive_message_chain('created_at.in_time_zone.to_date')
        .and_return(Date.new(2016, 11, 22))
    end

    it 'returns date feed item was created on' do
      expect(subject.reviewed_on).to eq Date.new(2016, 11, 22)
    end
  end

  describe '#tweet_status_id' do
    before do
      allow(tweet).to receive(:id).and_return '123456789'
    end

    it 'returns tweet ID' do
      expect(subject.tweet_status_id).to eq '123456789'
    end

    context 'with two part review' do
      let(:reply) { double('Tweet', id: '987654321') }

      it 'returns reply tweet ID' do
        expect(subject.tweet_status_id).to eq '987654321'
      end
    end
  end

  describe '#two_part?' do
    context 'without reply tweet' do
      it 'returns false' do
        expect(subject).to_not be_two_part
      end
    end

    context 'with reply tweet' do
      let(:reply) { :reply }

      it 'returns true' do
        expect(subject).to be_two_part
      end
    end
  end

  describe '#review_text' do
    before do
      allow(tweet).to receive(:text).and_return 'Many listen. Much wow'
    end

    it 'returns tweet ID' do
      expect(subject.review_text).to eq 'Many listen. Much wow'
    end

    context 'with two part review' do
      let(:reply) { double('Tweet', text: 'I no longer have eardrums') }

      it 'returns reply tweet ID' do
        expect(subject.review_text).to eq 'I no longer have eardrums'
      end
    end
  end

  describe '#listen_source' do
    let(:listen_url) { 'spotify.com' }

    before do
      allow(review).to receive(:listen_url).and_return(listen_url)
      allow(review).to receive(:listen_source).and_return(:source)
    end

    it 'returns review listen source' do
      expect(subject.listen_source).to eq review.listen_source
    end

    context 'with blank listen url' do
      let(:listen_url) { '' }

      it 'returns nil' do
        expect(subject.listen_source).to be_nil
      end
    end
  end

  describe '#album_id' do
    before { allow(review).to receive(:album_source_id).and_return '123ABC' }

    it 'returns review album source ID' do
      expect(subject.album_id).to eq '123ABC'
    end
  end

  describe '#album_of_the_month' do
    before { allow(review).to receive(:album_of_the_month).and_return(aotm) }

    context 'with review album of the month' do
      let(:aotm) { true }

      it 'returns true' do
        expect(subject).to be_album_of_the_month
      end
    end

    context 'with review not album of the month' do
      let(:aotm) { false }

      it 'returns false' do
        expect(subject).to_not be_album_of_the_month
      end
    end
  end
end
