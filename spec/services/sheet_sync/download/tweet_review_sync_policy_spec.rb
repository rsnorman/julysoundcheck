require 'rails_helper'

RSpec.describe SheetSync::Download::TweetReviewSyncPolicy do
  describe 'sync?' do
    let(:rating) { double('Rating', value: 5) }
    let(:listen_url) { 'spotify.com' }
    let(:genre) { 'Metal' }
    let(:tweet_review) do
      double('TweetReview', rating: rating,
                            listen_url: listen_url,
                            genre: genre,
                            album_of_the_month: true)
    end
    let(:tweet) do
      double('Tweet', tweet_review: tweet_review,
                      in_reply_to_tweet: reply_tweet)
    end
    let(:reply_tweet) { nil }
    let(:review_attrs) { Hash[:rating, 5, :album_of_the_month, true] }
    subject { described_class.new(tweet, review_attrs) }

    context 'with no updates' do
      it 'returns false' do
        expect(subject.sync?).to be_falsy
      end
    end

    context 'with no updates to reply tweet review' do
      let(:reply_tweet) { double('ReplyTweet', tweet_review: tweet_review) }
      before { allow(tweet).to receive(:tweet_review).and_return nil }

      it 'returns false' do
        expect(subject.sync?).to be_falsy
      end
    end

    context 'with no tweet review' do
      let(:tweet_review) { nil }

      it 'returns true' do
        expect(subject.sync?).to be_truthy
      end
    end

    context 'with review rating different than attribute' do
      let(:review_attrs) { super().merge(rating: 8) }

      it 'returns true' do
        expect(subject.sync?).to be_truthy
      end
    end

    context 'with review album of the month different than attribute' do
      let(:review_attrs) { super().merge(album_of_the_month: false) }

      it 'returns true' do
        expect(subject.sync?).to be_truthy
      end
    end

    context 'with listen url blank' do
      let(:listen_url) { '' }

      it 'returns true' do
        expect(subject.sync?).to be_truthy
      end
    end

    context 'with genre blank' do
      let(:listen_url) { '' }

      it 'returns true' do
        expect(subject.sync?).to be_truthy
      end
    end
  end
end
