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

  describe '#==' do
    subject { described_class.new('spotify.com') }

    let(:other_listen_source) { described_class.new(other_url) }

    context 'with url the same' do
      let(:other_url) { subject.url }

      it 'is equal to other listen source' do
        expect(subject).to eq other_listen_source
      end
    end

    context 'with url different' do
      let(:other_url) { 'different_url.com' }

      it 'is not equal to other listen source' do
        expect(subject).to_not eq other_listen_source
      end
    end
  end
end
