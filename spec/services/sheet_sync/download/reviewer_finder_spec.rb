require 'rails_helper'

RSpec.describe SheetSync::Download::ReviewerFinder do
  describe '#find' do
    let(:row) { double('SheetRow', reviewer: 'Dev Hynes') }
    let(:user) { double('User') }

    subject { described_class.new(row) }

    context 'with user existing' do
      before do
        allow(User).to receive(:find_by).with(name: 'Dev Hynes').and_return user
      end

      it 'returns user by reviewer name' do
        expect(subject.find).to eq user
      end
    end

    context 'with user not existing' do
      before do
        allow(User).to receive(:find_by).with(name: 'Dev Hynes').and_return nil
        allow(User).to receive(:create).with(name: 'Dev Hynes').and_return user
      end

      it 'creates a user with reviewer name' do
        expect(User).to receive(:create).with(name: 'Dev Hynes')
        subject.find
      end

      it 'returns the created user' do
        expect(subject.find).to eq user
      end
    end
  end
end
