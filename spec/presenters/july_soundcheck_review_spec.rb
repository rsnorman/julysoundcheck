require 'rails_helper'

RSpec.describe JulySoundcheckReview do
  let(:user) { double('User') }
  let(:review) { double('Review', user: user) }
  let(:feed_item) { double('FeedItem') }

  subject { described_class.new(review, feed_item) }

  it { is_expected.to delegate_method(:profile_image_uri).to(:user) }
  it { is_expected.to delegate_method(:name).to(:user).with_prefix }
  it { is_expected.to delegate_method(:rating).to(:review) }
  it { is_expected.to delegate_method(:artist).to(:review) }
  it { is_expected.to delegate_method(:album).to(:review) }
  it { is_expected.to delegate_method(:listen_url).to(:review) }
  it { is_expected.to delegate_method(:genre).to(:review) }
  it { is_expected.to delegate_method(:album_of_the_month).to(:review) }
  it { is_expected.to delegate_method(:description).to(:rating).with_prefix }

  describe '#text' do
    let(:review_text) { 'Great album!' }

    before { allow(review).to receive(:text).and_return(review_text) }

    it 'returns review text' do
      expect(subject.text).to eq 'Great album!'
    end

    context 'with no review text' do
      let(:review_text) { nil }

      it 'returns no review placeholder' do
        expect(subject.text).to eq '<em>No review</em>'
      end
    end
  end

  describe '#screen_name' do
    let(:twitter_screen_name) { 'the_flea' }

    before do
      allow(user)
        .to receive(:twitter_screen_name)
        .and_return(twitter_screen_name)
      allow(user)
        .to receive(:slug)
        .and_return('flea')
    end

    it 'returns user\'s twitter screen name' do
      expect(subject.screen_name).to eq 'the_flea'
    end

    context 'without twitter screen name for user' do
      let(:twitter_screen_name) { nil }

      it 'returns user slug' do
        expect(subject.screen_name).to eq 'flea'
      end
    end
  end

  describe '#twitter_account?' do
    context 'with twitter ID on user' do
      before { allow(user).to receive(:twitter_id).and_return 1 }

      it 'returns true' do
        expect(subject.twitter_account?).to be_truthy
      end
    end

    context 'with no twitter ID for user' do
      before { allow(user).to receive(:twitter_id).and_return nil }

      it 'returns true' do
        expect(subject.twitter_account?).to be_falsy
      end
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
