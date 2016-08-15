require 'spec_helper'
require './app/value_objects/rating'

RSpec.describe Rating do
  describe '.from_score' do
    subject { described_class.from_score('2+') }

    it 'sets the value from score' do
      expect(subject.value).to eq described_class::SCORES['2+']
    end
  end

  describe '.values_from_score' do
    subject { described_class.values_from_score('1') }

    it 'returns all values with same score number' do
      expect(subject).to eq([
        described_class::SCORES['1-'],
        described_class::SCORES['1'],
        described_class::SCORES['1+']
      ])
    end
  end

  describe '#to_s' do
    subject { described_class.new(9) }

    it 'returns short description' do
      expect(subject.to_s).to eq '3-'
    end
  end

  describe '#short_description' do
    subject { described_class.new(0) }

    it 'returns short description' do
      expect(subject.to_s).to eq '0-'
    end
  end

  describe '#description' do
    subject { described_class.new(3) }

    it 'returns short description' do
      expect(subject.description).to eq 'Barely listenable'
    end
  end
end
