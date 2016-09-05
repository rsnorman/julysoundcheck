require 'rails_helper'

RSpec.describe TweetReview do
  let(:user) { User.new }
  subject do
    described_class.new(rating: 4, listen_url: 'spotify', user: user)
  end

  it { is_expected.to belong_to :tweet }
  it { is_expected.to belong_to :user }
  it { is_expected.to have_one :feed_item }

  it do
    is_expected.to validate_uniqueness_of(:album).scoped_to(:artist, :user_id)
  end

  describe '#rating' do
    it 'returns rating value object' do
      expect(subject.rating).to eq Rating.new(4)
    end
  end

  describe '#listen_source' do
    it 'returns listen source value object' do
      expect(subject.listen_source).to eq ListenSource.new('spotify')
    end

    context 'without listen_url' do
      before { subject.listen_url = nil }

      it 'returns nil' do
        expect(subject.listen_source).to be_nil
      end
    end
  end

  describe 'before save' do
    let(:album_fetcher) { double('AlbumFetcher', fetch: '1234') }

    before do
      allow(AlbumIdFetcher)
        .to receive(:new)
        .with(subject.listen_source)
        .and_return(album_fetcher)
    end

    it 'sets album source id' do
      expect { subject.save }
        .to change(subject, :album_source_id)
        .from(nil)
        .to('1234')
    end

    context 'without listen_url' do
      before { subject.listen_url = nil }

      it 'doesn\'t set album source id' do
        subject.save
        expect(subject.album_source_id).to be_nil
      end
    end
  end
end
