FactoryGirl.define do
  factory :user do
    name "Ryan Norman"

    trait :twitter_user do
      twitter_screen_name 'rogerguelph'
      twitter_name 'Mayor Guelph'
      twitter_id '16950200'
    end

    trait :unsaved do
      name nil
    end
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


  factory :tweet_review do
    association :user, factory: [:user, :twitter_user]
    rating { Rating::SCORES.values.sample }
    sequence(:artist) { |n| %w(Radiohead Pixies Deerhunter)[n % 3] }
    sequence(:album) { |n| %w(Amnesiac Doolittle Monomania)[n % 3] }
    sequence(:listen_url) do |n|
      %w(
        https://play.spotify.com/album/6V9YnBmFjWmXCBaUVRCVXP
        https://play.spotify.com/album/6ymZBbRSmzAvoSGmwAFoxm
        https://play.spotify.com/album/68gYjtaIWlvCscoxuCqAiZ
      )[n % 3]
    end
    sequence(:genre) { |n| ['Indie Rock', 'Alternative', 'Rock'][n % 3] }
    album_of_the_month false
    after(:create) do |tweet_review|
      FactoryGirl.create(:feed_item, feedable: tweet_review,
                                     user: tweet_review.user)
    end
    sequence(:tweet) do |n|
      rating_desc = Rating.new(rating).short_description
      text = [
        "The highlights were undeniably worth the wait, and easily overcome its occasional patchiness #{rating_desc} #julysoundcheck",
        "The sheer weirdness seeps through #julysoundcheck #{rating_desc}",
        "Straight-up raw, bleeding garage rock, populating the songs with junkyards, leather jackets, and motorcycles #{rating_desc} #JulySoundcheck",
      ][n % 3]
      FactoryGirl.create(:tweet, text: text, user: user, tweeted_at: Time.current - 5.minutes)
    end

    trait :two_part do
      after(:create) do |tweet_review|
        reply_tweet = tweet_review.tweet
        initial_tweet = FactoryGirl.create(:tweet, text: "Today I'm going to review #{tweet_review.album} by #{tweet_review.artist}",
                                                   user: tweet_review.user)
        reply_tweet.update(in_reply_to_tweet_id: initial_tweet.id,
                           in_reply_to_status_id: initial_tweet.tweet_id)
        tweet_review.update(tweet: initial_tweet)
      end
    end
  end

  factory :tweet do
    tweet_id { SecureRandom.uuid }
    sequence(:text) do |n|
      [
        'Album Of The Month (AOTM) for me definitely has to be Camp Cope… no surprise since Hop Along is one of my favorite bands. #julysoundcheck',
        'Tomorrow, the fourth iteration of #JulySoundcheck begins. As usual, we listen to an album from an unknown artist, and tweet a review daily.',
      ][n % 2]
    end
    tweeted_at { Time.current }
    association :user, factory: [:user, :twitter_user, :unsaved]

    trait :feed_item do
      after(:create) do |tweet|
        FactoryGirl.create(:feed_item, feedable: tweet,
                                       user: tweet.user)
      end
    end

    trait :review do
      text 'These mysterious Mancunians craft a debut of exhilarating expanse and passion that sounds like indie rock and yet feels way bigger. 3+ #JulySoundcheck'
    end

    trait :reply do
      after(:create) do |tweet|
        tweet.reply = FactoryGirl.create(:tweet, user: tweet.user,
                                                 in_reply_to_tweet_id: tweet.id,
                                                 in_reply_to_status_id: tweet.tweet_id)
      end
    end
  end
end
