require 'rails_helper'

RSpec.describe FeedItem do
  it { should belong_to(:feedable) }
  it { should belong_to(:user) }

  # it { should validate_uniqueness_of(:feedable_id).scoped_to(:feedable_type) }
end
