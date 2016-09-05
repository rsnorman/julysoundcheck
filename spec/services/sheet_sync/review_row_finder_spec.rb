require 'spec_helper'
require './app/services/sheet_sync/review_row_finder'

RSpec.describe SheetSync::ReviewRowFinder do
  describe '#find' do
    let(:row) { double('SheetRow') }
    let(:worksheet) { double('Worksheet', each_row: [row]) }
    let(:tweet) { double('Tweet', tweet_id: SecureRandom.uuid, reply: reply) }
    let(:reply) { nil }
    let(:review) { double('Review', tweet: tweet) }
    let(:cell_content) { 'test' }

    before do
      allow(worksheet).to receive(:each_row).and_yield(row)
      allow(row)
        .to receive(:tweet)
        .with(with_formula: true)
        .and_return(cell_content)
    end

    subject { described_class.new(worksheet).find(review) }

    context 'with review not synced yet' do
      it 'returns nil' do
        expect(subject).to be_nil
      end
    end

    context 'with tweet matching link in cell' do
      let(:cell_content) { "twitter.com/status/#{tweet.tweet_id}" }

      it 'returns matching row' do
        expect(subject).to eq row
      end
    end

    context 'with tweet reply matching link in cell' do
      let(:reply) { double('Tweet', tweet_id: SecureRandom.uuid) }
      let(:cell_content) { "twitter.com/status/#{reply.tweet_id}" }

      it 'returns matching row' do
        expect(subject).to eq row
      end
    end
  end
end
