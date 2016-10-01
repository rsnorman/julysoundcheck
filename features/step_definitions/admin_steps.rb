Given(/^I am signed in as admin through Twitter$/) do
  @admin = FactoryGirl.create(:user, twitter_screen_name: ENV['TEST_TWITTER_SCREEN_NAME'],
                                    twitter_id: ENV['TEST_TWITTER_ID'])
  page.set_rack_session(access_token: ENV['TEST_TWITTER_ACCESS_TOKEN'],
                        access_token_secret: ENV['TEST_TWITTER_ACCESS_TOKEN_SECRET'])
end

Given(/^a non-admin user exists$/) do
  @user = FactoryGirl.create(:user, :twitter_user)
end

Given(/^a JulySoundcheck tweet with rating exists from a different user$/) do
  @tweet = FactoryGirl.create(:tweet, :feed_item, :review, tweet_id: '123456789', user: @user)
end

Then(/^I see the original user on the tweet review$/) do
  expect(@home_page.tweet_reviews.first).to have_user @user
end

Given(/^a JulySoundcheck tweet review exists from a different user$/) do
  tweet = FactoryGirl.create(:tweet, tweet_id: '987654321', user: @user)
  @tweet_review = FactoryGirl.create(:tweet_review, user: @user, tweet: tweet)
end
