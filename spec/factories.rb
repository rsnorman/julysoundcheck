FactoryGirl.define do
  factory :user do
    name "Ryan Norman"
    # email  "rsnorman15@gmail.com"
    # facebook_access_token "CAAFKoEw0PJABAHkXnS2ug68rYpg8l2VjdZAt9IIhKvPhZCnkR9"
    # facebook_access_token_expires_at Time.now
    # facebook_id "234234"
    # twitter_access_token "16950200-zfRfnbhjJRnJNFQ7NYJO8M015aaucrCGqJ81zOg"
    # twitter_access_secret "1KfojHF14c28GTirds8yZnZrT18Ib1hDZ5WSP2p4"
    # twitter_id "16950200"
  end

  factory :review, class: TweetReview do
    user
    rating { Rating::SCORES.values.sample }
    sequence(:artist) { |n| %w(Interpol Wilco Deafheaven)[n % 3] }
    sequence(:album) { |n| %w(Antics Summerteeth Sunbather)[n % 3] }
    sequence(:listen_url) do |n|
      %w(
        https://play.spotify.com/album/58fDEyJ5XSau8FRA3y8Bps
        https://play.spotify.com/album/1JpaFJzzcsiulO6MdIcQdK
        https://play.spotify.com/album/6zEacAdWHLaclKB2C39mag
      )[n % 3]
    end
    sequence(:genre) { |n| ['Indie Rock', 'Alt Country', 'Blackgaze'][n % 3] }
    sequence(:text) do |n|
      [
        'Exudes a preceding aura of heaviness-- even the packaging is heavy',
        'An album as wonderfully ambiguous and beautifully uncertain as life itself',
        'An epic mix of intense black metal and chiming post-rock'
      ][n % 3]
    end
    reviewed_at { Time.current }
    album_of_the_month false
    after(:create) do |review|
      FactoryGirl.create(:feed_item, feedable: review,
                                     user: review.user)
    end
  end

  factory :feed_item do
  end

  #
  # factory :tweet_review do
  #
  # end
  #
  # factory :tweet do
  #
  # end
end
