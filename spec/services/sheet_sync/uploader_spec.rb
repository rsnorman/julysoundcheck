require 'rails_helper'

RSpec.describe SheetSync::Uploader do
  describe '#upload' do
    let(:new_row) { double('SheetRow').as_null_object }
    let(:worksheet) { double('Worksheet') }
    let(:review_row_finder_class) { double('ReviewRowFinderClass') }
    let(:review_row_finder) { double('ReviewRowFinder') }
    let(:tweet_review) do
      double('TweetReview', artist: 'Pavement',
                            album: 'Wowee Zowee',
                            listen_url: 'http://spotify.com/wowzowee',
                            listen_source: listen_source,
                            rating: rating,
                            user: user,
                            genre: 'Alternative',
                            album_of_the_month: false,
                            tweet: tweet)
    end
    let(:rating) { double('Rating', short_description: '3+') }
    let(:listen_source) { double('ListenSource', source: :spotify) }
    let(:tweet) do
      double('Tweet', user: user,
                      tweet_id: SecureRandom.uuid,
                      text: 'Dark and moody',
                      tweeted_at: Time.current - 1.day,
                      reply: nil)
    end
    let(:user) do
      double('User', twitter_screen_name: 'TheRobertSmith',
                     twitter_name: 'Robert Smith Official',
                     name: 'Robert Smith')
    end

    subject do
      described_class.new(worksheet: worksheet,
                          review_row_finder: review_row_finder_class)
    end

    before do
      allow(worksheet).to receive(:build_row).and_return new_row
      allow(review_row_finder_class)
        .to receive(:new)
        .and_return(review_row_finder)
      allow(review_row_finder)
        .to receive(:find)
        .with(tweet_review)
        .and_return(nil)
      allow(worksheet).to receive(:save)
    end

    it 'sets the artist' do
      expect(new_row).to receive(:artist=).with('Pavement')
      subject.upload(tweet_review)
    end

    it 'sets the album' do
      expect(new_row).to receive(:album=).with('Wowee Zowee')
      subject.upload(tweet_review)
    end

    it 'sets the album listen URL' do
      expect(new_row).to receive(:source=).with('=HYPERLINK("http://spotify.com/wowzowee","Spotify")')
      subject.upload(tweet_review)
    end

    it 'sets the album tweet review text' do
      expect(new_row)
        .to receive(:review=)
        .with('=HYPERLINK("https://www.twitter.com/TheRobertSmith/status/' \
              "#{tweet.tweet_id}\", \"Dark and moody\")")
      subject.upload(tweet_review)
    end

    it 'sets the reviewer' do
      expect(new_row).to receive(:reviewer=).with('Robert Smith')
      subject.upload(tweet_review)
    end

    it 'sets the date reviewed when tweet was created' do
      expect(new_row)
        .to receive(:date_reviewed=)
        .with((Time.current - 1.day).strftime('%b/%e/%Y'))
      subject.upload(tweet_review)
    end

    it 'sets the rating' do
      expect(new_row).to receive(:rating=).with('3+')
      subject.upload(tweet_review)
    end

    it 'sets the genre' do
      expect(new_row).to receive(:genre=).with('Alternative')
      subject.upload(tweet_review)
    end

    it 'sets whether or not flagged as Album Of The Month' do
      expect(new_row).to receive(:aotm=).with(nil)
      subject.upload(tweet_review)
    end

    it 'saves the worksheet' do
      expect(worksheet).to receive(:save)
      subject.upload(tweet_review)
    end

    context 'with no user name' do
      before do
        allow(user).to receive(:name).and_return nil
      end

      it 'sets the reviewer with twitter screen name' do
        expect(new_row).to receive(:reviewer=).with('Robert Smith Official')
        subject.upload(tweet_review)
      end
    end

    context 'with Album Of The Month flagged' do
      before do
        allow(tweet_review).to receive(:album_of_the_month).and_return true
      end

      it 'sets the Album Of The Month' do
        expect(new_row).to receive(:aotm=).with('*******')
        subject.upload(tweet_review)
      end
    end

    context 'with reply on tweet' do
      let(:reply) do
        double('Tweet', text: 'Peers into my soul', tweet_id: SecureRandom.uuid)
      end

      before do
        allow(tweet).to receive(:reply).and_return(reply)
      end

      it 'sets review text from reply' do
        expect(new_row)
          .to receive(:review=)
          .with('=HYPERLINK("https://www.twitter.com/TheRobertSmith/status/' \
                "#{reply.tweet_id}\", \"Peers into my soul\")")
        subject.upload(tweet_review)
      end
    end

    context 'with review already synced to sheet' do
      let(:existing_row) { double('Row').as_null_object }

      before do
        allow(review_row_finder)
          .to receive(:find)
          .with(tweet_review)
          .and_return(existing_row)
      end

      it 'syncs to existing row' do
        expect(existing_row).to receive(:artist=)
        subject.upload(tweet_review)
      end
    end

    context 'with no tweet' do
      before do
        allow(tweet_review).to receive(:tweet).and_return nil
        allow(tweet_review).to receive(:text).and_return 'Great album!'
        allow(tweet_review)
          .to receive(:reviewed_at)
          .and_return Time.current - 3.days
      end

      it 'sets review directly from review text' do
        expect(new_row).to receive(:review=).with('Great album!')
        subject.upload(tweet_review)
      end

      it 'sets date reviewed from reviewed_at' do
        expect(new_row).to receive(:date_reviewed=)
          .with((Time.current - 3.days).strftime('%b/%e/%Y'))
        subject.upload(tweet_review)
      end
    end
  end
end
