require 'spec_helper'
require './app/value_objects/listen_source'

RSpec.describe ListenSource do
  describe '#source' do
    subject { described_class.new(url) }

    context 'with spotify url' do
      let(:url) { 'http://spotify.com/asflsdjfaslk' }

      it 'returns :spotify' do
        expect(subject.source).to eq :spotify
      end

      context 'with spotify playlist url' do
        let(:url) { 'http://spotify.com/asflsdjfaslk&list=2asdfaf' }

        it 'returns :link' do
          expect(subject.source).to eq :link
        end
      end
    end

    context 'with bandcamp url' do
      let(:url) { 'http://bandcamp.com/asflsdjfaslk' }

      it 'returns :bandcamp' do
        expect(subject.source).to eq :bandcamp
      end
    end

    context 'with youtube url' do
      let(:url) { 'http://youtube.com/asflsdjfaslk' }

      it 'returns :youtube' do
        expect(subject.source).to eq :youtube
      end
    end

    context 'with soundcloud url' do
      let(:url) { 'http://soundcloud.com/asflsdjfaslk' }

      it 'returns :souncloud' do
        expect(subject.source).to eq :soundcloud
      end
    end

    context 'with un-embedable url' do
      let(:url) { 'http://asdflkjlskf.com/asflsdjfaslk' }

      it 'returns :link' do
        expect(subject.source).to eq :link
      end
    end
  end
end
