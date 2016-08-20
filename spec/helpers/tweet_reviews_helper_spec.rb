require 'rails_helper'

RSpec.describe TweetReviewsHelper do
  describe '#rating_options' do
    it 'includes default unselected option' do
      expect(helper.rating_options).to include('-- Choose Rating --' => nil)
    end


    Rating::SCORES.each_pair do |score, value|
      it "includes option for #{score}" do
        expect(helper.rating_options)
          .to include("#{Rating::DESCRIPTIONS[value]} (#{score})" => value)
      end
    end
  end

  describe '#rating_group_links' do
    Rating::SCORE_GROUPS.each do |value, name|
      it "includes list item with link to reviews rated as \"#{name}\"" do
        expect(helper.rating_group_links)
          .to include("<li>#{link_to(name, ratings_path(value))}</li>")
      end
    end

    it 'orders by highest rated group first' do
      expect(helper.rating_group_links).to match(/3.*2.*1.*0/)
    end
  end

  describe '#rating_group_descripions' do
    it 'returns group description' do
      expect(helper.rating_group_description('1')).to eq 'Listen Once'
    end

    context 'with rating with +' do
      it 'returns group description' do
        expect(helper.rating_group_description('1+')).to eq 'Listen Once'
      end
    end

    context 'with rating with -' do
      it 'returns group description' do
        expect(helper.rating_group_description('1-')).to eq 'Listen Once'
      end
    end
  end

  describe '#group_album_results' do
    let(:album1) { double('Album') }
    let(:album2) { double('Album') }
    let(:albums) { [album1, album2] }

    it 'returns array of array of albums' do
      expect(helper.group_albums_results(albums)).to eq([[album1, album2]])
    end

    context 'with more than 3 albums' do
      let(:album3) { double('Album') }
      let(:album4) { double('Album') }
      let(:albums) { super().concat([album3, album4]) }

      it 'returns 3 albums in first element and fourth in second' do
        expect(helper.group_albums_results(albums))
          .to eq([[album1, album2, album3], [album4]])
      end
    end

    context 'with exactly 3 albums' do
      let(:album3) { double('Album') }
      let(:albums) { super().concat([album3]) }

      it 'returns 3 albums in first element and no second element' do
        expect(helper.group_albums_results(albums))
          .to eq([[album1, album2, album3]])
      end
    end
  end
end
