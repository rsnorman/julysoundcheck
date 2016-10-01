require 'rails_helper'

RSpec.describe SheetSync::Worksheet do
  let(:session) { double('GDriveSession') }
  let(:sheet_key) { SecureRandom.uuid }
  let(:spreadsheet) { double('Spreadsheet') }
  let(:sheet) { double('Sheet') }

  before do
    allow(GoogleDrive)
      .to receive(:saved_session)
      .with(described_class::GOOGLE_DRIVE_CREDS_FILEPATH)
      .and_return(session)
    allow(session)
      .to receive(:spreadsheet_by_key)
      .with(sheet_key)
      .and_return(spreadsheet)
    allow(spreadsheet).to receive(:worksheets).and_return([sheet])
    allow(sheet)
      .to receive(:[])
      .with(2, 1)
      .and_return('International Noise Conspiracy')
  end

  subject { described_class.new(sheet_key: sheet_key) }

  it { is_expected.to delegate_method(:save).to(:sheet) }

  describe '#each_row' do
    let(:row1) { double('SheetRow') }
    let(:row2) { double('SheetRow') }
    let(:calls) { [] }

    before do
      allow(sheet).to receive(:num_rows).and_return 3
      allow(SheetSync::SheetRow).to receive(:new).with(subject, 2).and_return(row1)
      allow(SheetSync::SheetRow).to receive(:new).with(subject, 3).and_return(row2)
    end

    context 'with only row parameter' do
      let(:callback) { -> (row) { calls << row } }

      it 'calls block for each sheet row' do
        subject.each_row(&callback)
        expect(calls).to eq([row1, row2])
      end
    end

    context 'with row and column parameters' do
      let(:callback) { -> (row, index) { calls << [row, index] } }

      it 'calls block for each sheet row at index' do
        subject.each_row(&callback)
        expect(calls).to eq([[row1, 0], [row2, 1]])
      end
    end
  end

  describe '#value' do
    let(:row) { 2 }
    let(:col) { 1 }

    before do
      allow(sheet)
        .to receive(:[])
        .with(2, 1)
        .and_return('International Noise Conspiracy')
    end

    it 'returns sheet value at position' do
      expect(subject.value(row, col)).to eq 'International Noise Conspiracy'
    end
  end

  describe '#formula_value' do
    let(:row) { 3 }
    let(:col) { 1 }

    before do
      allow(sheet)
        .to receive(:input_value)
        .with(3, 1)
        .and_return('LINK_TO=http://spotify.com/2asfa325')
    end

    it 'returns formula value at position' do
      expect(subject.formula_value(row, col))
        .to eq 'LINK_TO=http://spotify.com/2asfa325'
    end
  end

  describe '#set_value' do
    let(:row) { 4 }
    let(:col) { 2 }

    it 'sets value at position' do
      expect(sheet).to receive(:[]=).with(row, col, '3+')
      subject.set_value(4, 2, '3+')
    end
  end

  describe '#build_row' do
    before do
      allow(sheet).to receive(:num_rows).and_return 4
    end

    it 'builds new row at end of sheet' do
      expect(SheetSync::SheetRow).to receive(:new).with(subject, 5)
      subject.build_row
    end
  end
end
