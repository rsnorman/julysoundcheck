require 'spec_helper'
require './app/services/sheet_sync/sheet_row'

RSpec.describe SheetSync::SheetRow do
  let(:worksheet) { double('Worksheet') }
  let(:row_index) { 2 }

  subject { described_class.new(worksheet, row_index) }

  described_class::ATTRIBUTE_COLUMNS.each_pair do |name, col_index|
    describe '#artist' do
      it 'retrieves value from sheet' do
        expect(worksheet).to receive(:value).with(row_index, col_index)
        subject.public_send(name)
      end

      context 'retrieving formula value' do
        it 'retrieves value from sheet' do
          expect(worksheet)
            .to receive(:formula_value)
            .with(row_index, col_index)
          subject.public_send(name, with_formula: true)
        end
      end
    end

    describe "##{name}=" do
      it 'sets the value' do
        expect(worksheet)
          .to receive(:set_value)
          .with(row_index, col_index, 'Husker Du')
        subject.public_send("#{name}=", 'Husker Du')
      end
    end
  end

  describe '#tweet' do
    it 'returns review value' do
      expect(worksheet)
        .to receive(:value)
        .with(row_index, described_class::ATTRIBUTE_COLUMNS[:review])
      subject.tweet
    end
  end
end
