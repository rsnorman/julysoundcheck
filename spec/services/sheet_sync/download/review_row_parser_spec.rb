require 'rails_helper'

RSpec.describe SheetSync::Download::ReviewRowParser do
  describe '#parse' do
    let(:row) do
      double('SheetRow', artist: 'The Babies',
                         album: 'Our House On The Hill',
                         genre: 'Indie Rock',
                         rating: '3-',
                         source: '=HYPERLINK("http://spotify.com/12345","Spotify")',
                         review: review,
                         aotm: aotm,
                         date_reviewed: date_reviewed).as_null_object
    end
    let(:review) { 'Punchy indie rock!' }
    let(:date_reviewed) { '6/1/2016' }
    let(:aotm) { '' }
    let(:rating) { double('Rating', value: 9) }
    let(:rating_score_convertor) do
      double('RatingScoreConvertor').tap do |rsc|
        allow(rsc).to receive(:from_score).with('3-').and_return rating
      end
    end

    subject do
      described_class.new(row, rating_score_convertor: rating_score_convertor)
    end

    it 'returns artist attribute' do
      expect(subject.parse).to include(artist: 'The Babies')
    end

    it 'returns album attribute' do
      expect(subject.parse).to include(album: 'Our House On The Hill')
    end

    it 'returns genre attribute' do
      expect(subject.parse).to include(genre: 'Indie Rock')
    end

    it 'returns listen_url attribute' do
      expect(subject.parse).to include(listen_url: 'http://spotify.com/12345')
    end

    it 'returns rating attribute' do
      expect(subject.parse).to include(rating: 9)
    end

    it 'returns text attribute' do
      expect(subject.parse).to include(text: 'Punchy indie rock!')
    end

    it 'returns reviewed_at attribute' do
      expect(subject.parse).to include(reviewed_at: Date.new(2016, 6, 1))
    end

    it 'returns album_of_the_month attribute' do
      expect(subject.parse).to include(album_of_the_month: false)
    end

    context 'with album of the month cell containing text' do
      let(:aotm) { 'Whoop, whoop!' }

      it 'returns album_of_the_month attribute as true' do
        expect(subject.parse).to include(album_of_the_month: true)
      end
    end

    context 'with reviewed_at equal to current day' do
      let(:date_reviewed) { Date.current.strftime('%m/%d/%Y') }

      it 'returns reviewed_at attribute set to current time' do
        expect(subject.parse[:reviewed_at])
          .to be_within(1.second).of(Time.current)
      end
    end

    context 'with blank values in row cell' do
      let(:review) { '' }

      it 'doesn\'t include empty attributes' do
        expect(subject.parse).not_to have_key(:text)
      end
    end

    context 'with nil values in row cell' do
      let(:review) { nil }

      it 'doesn\'t include empty attributes' do
        expect(subject.parse).not_to have_key(:text)
      end
    end
  end
end
