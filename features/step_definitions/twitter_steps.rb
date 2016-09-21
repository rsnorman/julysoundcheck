Given(/^I have (\d+) recent tweets$/) do |number_of_tweets|
  @user ||= @user || FactoryGirl.create(:user, twitter_screen_name: ENV['TEST_TWITTER_SCREEN_NAME'],
                                               twitter_id: ENV['TEST_TWITTER_ID'])
  @tweets = []
  number_of_tweets.to_i.times do
    @tweets << FactoryGirl.create(:tweet, user: @user)
  end
end

When(/^I click the Twitter Sign In button$/) do
  @home_page.twitter_sidebar.login
end

When(/^I login with my Twitter credentials$/) do
  TwitterLogin.new.tap do |twitter_login|
    twitter_login.fill_in_login_details
    twitter_login.submit.redirect
  end
end

Then(/^I see my recent tweets$/) do
  expect(@home_page.recent_tweets).to have_tweet @tweets.last
  expect(@home_page.recent_tweets).to have_tweet @tweets.third
  expect(@home_page.recent_tweets).to have_tweet @tweets.second
  expect(@home_page.recent_tweets).not_to have_tweet @tweets.first
end

Given(/^I am signed in through Twitter$/) do
  @user = FactoryGirl.create(:user, twitter_screen_name: ENV['TEST_TWITTER_SCREEN_NAME'],
                                    twitter_id: ENV['TEST_TWITTER_ID'])
  page.set_rack_session(access_token: ENV['TEST_TWITTER_ACCESS_TOKEN'],
                        access_token_secret: ENV['TEST_TWITTER_ACCESS_TOKEN_SECRET'])
end
