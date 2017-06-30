require 'rails_helper'

RSpec.describe User do
  it { should have_many(:tweets) }
  it { should have_many(:tweet_reviews) }
  it { should have_many(:feed_items) }

  describe '#name' do
    subject { described_class.new(name: 'John Frusciante') }

    it 'returns the user\'s name' do
      expect(subject.name).to eq 'John Frusciante'
    end

    context 'without a name' do
      before do
        subject.name = nil
        subject.twitter_name = 'Official John Frusciante'
      end

      it 'returns the user\'s twitter name' do
        expect(subject.name).to eq 'Official John Frusciante'
      end
    end
  end

  describe 'before save' do
    subject do
      described_class.new(name: 'John Frusciante',
                          email: 'jfrusc@gmail.com',
                          password: SecureRandom.uuid)
    end

    it 'sets the user slug' do
      expect { subject.save }
        .to change(subject, :slug)
        .from(nil)
        .to('john_frusciante')
    end

    context 'without a name' do
      before do
        subject.name = nil
      end

      it 'does not set a slug' do
        subject.save
        expect(subject.slug).to be_nil
      end
    end

    context 'with non-alphnumeric characters' do
      before do
        subject.name = subject.name + '!'
      end

      it 'removes non-alphanumerica characters from slug' do
        expect { subject.save }
          .to change(subject, :slug)
          .from(nil)
          .to('john_frusciante')
      end
    end
  end
end
