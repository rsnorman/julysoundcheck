require 'rails_helper'

RSpec.describe TwitterClient do
  describe '#client' do
    let(:configured_client) { double('ConfiguredTwitterClient').as_null_object }
    let(:access_secret) { SecureRandom.uuid }

    before do
      allow(Twitter::REST::Client)
        .to receive(:new)
        .and_yield(configured_client)
        .and_return(configured_client)
    end

    it 'returns configured client' do
      expect(subject.client).to eq configured_client
    end

    it 'configures with consumer key' do
      expect(configured_client)
        .to receive(:consumer_key=)
        .with(described_class::TWITTER_KEY)
      subject.client
    end

    it 'configures with consumer secret' do
      expect(configured_client)
        .to receive(:consumer_secret=)
        .with(described_class::TWITTER_SECRET)
      subject.client
    end

    context 'with access token' do
      let(:access_token) { SecureRandom.uuid }

      subject { described_class.new(access_token: access_token) }

      it 'configures with access token' do
        expect(configured_client)
          .to receive(:access_token=)
          .with(access_token)
        subject.client
      end
    end

    context 'with access secret' do
      let(:access_secret) { SecureRandom.uuid }

      subject { described_class.new(access_secret: access_secret) }

      it 'configures with access secret' do
        expect(configured_client)
          .to receive(:access_token_secret=)
          .with(access_secret)
        subject.client
      end
    end
  end
end
