require 'rails_helper'

RSpec.describe Album do
  let(:artist) { double('Artist', name: 'Mars Volta') }
  let(:album_hash) do
    double('AlbumHash', name: 'De-Loused in the Comatorium', artists: [artist])
  end

  subject { described_class.new(album_hash) }

  describe '#artist' do
    it 'returns artist name' do
      expect(subject.artist).to eq 'Mars Volta'
    end
  end

  describe '#name' do
    it 'returns album name' do
      expect(subject.name).to eq 'De-Loused in the Comatorium'
    end
  end

  describe '#release_date' do
    let(:release_date) { '1/1/2016' }

    before do
      allow(album_hash).to receive(:release_date).and_return(release_date)
    end

    it 'returns release date' do
      expect(subject.release_date).to eq Date.new(2016, 1, 1)
    end

    context 'with release date blank' do
      let(:release_date) { nil }

      it 'returns nil' do
        expect(subject.release_date).to be_nil
      end
    end

    context 'with invalid release date' do
      let(:release_date) { '34/59/100' }

      it 'returns nil' do
        expect(subject.release_date).to be_nil
      end
    end
  end

  describe '#image_url' do
    before do
      allow(album_hash)
        .to receive(:images)
        .and_return([{ 'url' => 'large.jpg' }, { 'url' => 'thumb.jpg' }])
    end

    it 'returns thumbnail url' do
      expect(subject.image_url).to eq URI('thumb.jpg')
    end
  end

  describe '#url' do
    before do
      expect(album_hash).to receive(:id).and_return('1234ABC')
    end

    it 'returns spotify URL' do
      expect(subject.url).to eq 'https://play.spotify.com/album/1234ABC'
    end
  end
end
