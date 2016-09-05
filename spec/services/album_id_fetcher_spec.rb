require 'rails_helper'

RSpec.describe AlbumIdFetcher do
  describe '#fetch' do
    let(:listen_source) { double('ListenSource', source: source, url: url) }

    subject { described_class.new(listen_source) }

    context 'with spotify source' do
      let(:url) { 'https://play.spotify.com/album/4jyWDa1yM9ul7zgUdR80hw' }
      let(:source) { :spotify }

      it 'returns spotify album ID' do
        expect(subject.fetch).to eq '4jyWDa1yM9ul7zgUdR80hw'
      end
    end

    context 'with youtube source' do
      let(:url) { 'https://www.youtube.com/watch?v=G9ZiU7ahZso' }
      let(:source) { :youtube }

      it 'returns youtube album ID' do
        expect(subject.fetch).to eq 'G9ZiU7ahZso'
      end

      context 'with youtube playlist' do
        let(:url) do
          'https://www.youtube.com/watch?v=ccHNTriMSrE&list=PL851BD6D1D5E73A79'
        end

        it 'returns youtube start video and playlist ID' do
          expect(subject.fetch).to eq 'ccHNTriMSrE?list=PL851BD6D1D5E73A79'
        end
      end
    end

    context 'with bandcamp source' do
      let(:url) do
        'http://girlslivingoutsidesocietysshit.bandcamp.com/album/trans-day-of-revenge'
      end
      let(:source) { :bandcamp }

      before do
        stub_request(:get, url).to_return(
          status: 200,
          body: '<html><body></body></html><!-- album id 1947465492 -->'
        )
      end

      it 'returns bandcamp album ID' do
        expect(subject.fetch).to eq '1947465492'
      end
    end

    context 'with soundcloud source' do
      let(:url) do
        'https://soundcloud.com/aiww/sets/the-divine-comedy'
      end
      let(:source) { :soundcloud }

      before do
        stub_request(:get, url).to_return(
          status: 200,
          body: '<html><head><meta property="twitter:app:url:googleplay" ' \
                'content="soundcloud://playlists:6822079"></head><body></body></html>'
        )
      end

      it 'returns soundcloud album ID' do
        expect(subject.fetch).to eq '6822079'
      end
    end

    context 'with nil listen source' do
      let(:listen_source) { nil }

      it 'returns nil' do
        expect(subject.fetch).to be_nil
      end
    end

    context 'with listen source not recognized' do
      let(:source) { :garbage }
      let(:url) { 'doesntmatter.com' }

      it 'returns nil' do
        expect(subject.fetch).to be_nil
      end
    end
  end
end
