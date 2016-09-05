require 'rails_helper'

RSpec.describe JulySoundcheckTweet do
  let(:user) { double('User') }
  let(:reply) { nil }
  let(:tweet) { double('Tweet', user: user, reply: reply) }
  let(:feed_item) { double('FeedItem') }

  subject { described_class.new(tweet, feed_item) }

  it { is_expected.to delegate_method(:text).to(:tweet) }
  it { is_expected.to delegate_method(:id).to(:tweet) }
  it { is_expected.to delegate_method(:profile_image_uri).to(:user) }

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

  describe 'tweeted_on' do
    before do
      allow(feed_item)
        .to receive_message_chain('created_at.in_time_zone.to_date')
        .and_return(Date.new(2016, 11, 22)) if feed_item
    end

    it 'returns date feed item was created on' do
      expect(subject.tweeted_on).to eq Date.new(2016, 11, 22)
    end

    context 'with no feed item' do
      let(:feed_item) { nil }

      before do
        allow(tweet)
          .to receive_message_chain('tweeted_at.in_time_zone.to_date')
          .and_return(Date.new(2016, 12, 5))
      end

      it 'returns date tweet was tweeted on' do
        expect(subject.tweeted_on).to eq Date.new(2016, 12, 5)
      end
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

  describe '#rating' do
    before { allow(tweet).to receive(:text).and_return text }

    context 'without review score in tweet' do
      let(:text) { 'Can\'t wait to start #JulySoundcheck' }

      it 'returns nil' do
        expect(subject.rating).to be_nil
      end
    end

    context 'with review score in tweet' do
      let(:text) { 'Monomania is an exhilerating listen #JulySoundcheck 3+' }

      it 'returns rating from review score' do
        expect(subject.rating).to eq Rating.from_score('3+')
      end
    end

    context 'with review score before #julysoundcheck hashtag' do
      let(:text) { 'Monomania is an exhilerating listen 3+ #JulySoundcheck' }

      it 'returns rating from review score' do
        expect(subject.rating).to eq Rating.from_score('3+')
      end
    end

    context 'with two numbers in tweet' do
      let(:text) do
        'Number 1 for me… Monomania is an exhilerating listen 3+'
      end

      it 'returns rating from review score' do
        expect(subject.rating).to eq Rating.from_score('3+')
      end
    end
  end
end
