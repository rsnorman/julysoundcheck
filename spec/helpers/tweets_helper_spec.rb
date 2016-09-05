require 'rails_helper'

RSpec.describe TweetsHelper do
  describe '#remove_hashtag_and_rating' do
    subject { helper.remove_hashtag_and_rating(text) }

    context 'with no hashtag or rating' do
      let(:text) { 'Great album!' }

      it 'leaves text unchanged' do
        expect(subject).to eq 'Great album!'
      end
    end

    context 'with julysoundcheck hashtag' do
      let(:text) { 'Great album! #JulySoundcheck' }

      it 'removes hashtag' do
        expect(subject).to eq 'Great album!'
      end
    end

    context 'with julysoundcheck hashtag and extra space' do
      let(:text) { 'Great album! #JulySoundcheck ' }

      it 'removes hashtag' do
        expect(subject).to eq 'Great album!'
      end
    end

    context 'with rating' do
      let(:text) { 'Great album! 3' }

      it 'removes rating' do
        expect(subject).to eq 'Great album!'
      end
    end

    context 'with + rating' do
      let(:text) { 'Great album! 3+' }

      it 'removes rating' do
        expect(subject).to eq 'Great album!'
      end
    end

    context 'with - rating' do
      let(:text) { 'Great album! 3-' }

      it 'removes rating' do
        expect(subject).to eq 'Great album!'
      end
    end

    context 'with rating and julysoundcheck hashtag' do
      let(:text) { 'Great album! 3 #julysoundcheck' }

      it 'removes rating and hashtag' do
        expect(subject).to eq 'Great album!'
      end
    end

    context 'with + rating with julysoundcheck hashtag' do
      let(:text) { 'Great album! 3+ #julysoundcheck' }

      it 'removes rating and hashtag' do
        expect(subject).to eq 'Great album!'
      end
    end

    context 'with - rating with julysoundcheck hashtag' do
      let(:text) { 'Great album! 3- #julysoundcheck' }

      it 'removes rating and hashtag' do
        expect(subject).to eq 'Great album!'
      end
    end

    context 'with julysoundcheck hashtag not at end of text' do
      let(:text) { 'Great #JulySoundcheck album! 3-' }

      it 'doesn\'t remove hashtag' do
        expect(subject).to eq 'Great #JulySoundcheck album!'
      end
    end
  end

  context '#can_edit?' do
    let(:tweet) { double('Tweet') }
    let(:twitter_user) { double('TwitterUser', screen_name: 'trent_reznor') }

    before { allow(helper).to receive(:twitter_user).and_return twitter_user }

    context 'without twitter user signed in' do
      let(:twitter_user) { nil }

      it 'returns false' do
        expect(helper.can_edit?(tweet)).to be_falsy
      end
    end

    context 'with user screen name equal to admin screen name' do
      before do
        allow(ENV)
          .to receive(:[])
          .with('ADMIN_TWITTER_SCREEN_NAME')
          .and_return 'trent_reznor'
      end

      it 'returns true' do
        expect(helper.can_edit?(tweet)).to be_truthy
      end
    end

    context 'with user screen name matching tweet screen name' do
      before do
        allow(tweet)
          .to receive(:screen_name)
          .and_return twitter_user.screen_name
      end

      it 'returns true' do
        expect(helper.can_edit?(tweet)).to be_truthy
      end
    end

    context 'with user screen name matching tweet screen name' do
      before do
        allow(tweet)
          .to receive(:screen_name)
          .and_return 'robin_finck'
      end

      it 'returns false' do
        expect(helper.can_edit?(tweet)).to be_falsy
      end
    end
  end

  describe '#link_recommender' do
    context 'with no mentions in text' do
      let(:text) { 'Love this album!' }

      it 'returns unchanged text' do
        expect(helper.link_recommender(text)).to eq 'Love this album!'
      end
    end

    context 'with mention in text' do
      let(:text) { 'Love this album, thanks @trent_reznor!' }

      it 'returns unchanged text' do
        expect(helper.link_recommender(text)) .to eq(
          'Love this album, thanks ' \
          '<a href="/reviewers/trent_reznor/feed">@trent_reznor</a>!'
        )
      end
    end

    context 'with multiple mentions in text' do
      let(:text) { 'Love this album, thanks @trent_reznor and @robin_finck!' }

      it 'returns unchanged text' do
        expect(helper.link_recommender(text)) .to eq(
          'Love this album, thanks ' \
          '<a href="/reviewers/trent_reznor/feed">@trent_reznor</a> and ' \
          '<a href="/reviewers/robin_finck/feed">@robin_finck</a>!'
        )
      end
    end
  end

  describe '#recent_tweets' do
    let(:user) { double('User') }

    before { allow(helper).to receive(:current_user).and_return user }

    context 'with current user' do
      let(:tweet_class) { Tweet }
      let(:tweets) { [double('Tweet'), double('Tweet'), double('Tweet')] }
      let(:jsc_tweets) do
        [double('JSCTweet'), double('JSCTweet'), double('JSCTweet')]
      end

      before do
        allow(tweet_class)
          .to receive(:where)
          .with(user: user, in_reply_to_tweet_id: nil)
          .and_return(tweet_class)
        allow(tweet_class)
          .to receive(:includes)
          .with(:reply)
          .and_return(tweet_class)
        allow(tweet_class)
          .to receive(:limit)
          .with(3)
          .and_return(tweets)

        allow(JulySoundcheckTweet)
          .to receive(:new)
          .and_return(*jsc_tweets)
      end

      it 'returns 3 tweets wrapped in presenter' do
        expect(helper.recent_tweets).to eq jsc_tweets
      end
    end

    context 'without current user' do
      let(:user) { nil }

      it 'returns empty array' do
        expect(helper.recent_tweets).to be_empty
      end
    end
  end
end
