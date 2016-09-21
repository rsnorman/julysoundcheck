Given(/^I have a JulySoundcheck tweet with rating$/) do
  @tweet = FactoryGirl.create(:tweet, :feed_item, :review, tweet_id: '123456789', user: @user)
end

When(/^I edit the tweet$/) do
  @create_review_page = @home_page.tweets.first.create_review
end

When(/^I add the review details to the tweet$/) do
  @create_review_page.set_artist('WU LYF')
  @create_review_page.set_album('Go Tell Fire To The Mountain')
  @create_review_page.set_genre('Heavy Pop')
  @create_review_page.set_listen_url('https://play.spotify.com/album/3YUCk9Q1vjWsZsTur93sQP')
end

When(/^I create the tweet review$/) do
  @create_review_page.create
end

Then(/^I see the added review details to the tweet$/) do
  tweet_review_section = @home_page.tweet_reviews.first
  @tweet_review = @tweet.tweet_review
  expect(tweet_review_section.user_name).to have_content @tweet_review.user.name
  expect(tweet_review_section.twitter_user_name).to have_content @tweet_review.user.twitter_screen_name
  expect(tweet_review_section).to have_profile_link_to @tweet_review.user
  expect(tweet_review_section).to be_reviewed_on @tweet_review.created_at
  expect(tweet_review_section.rating).to have_content @tweet_review.rating.to_s
  expect(tweet_review_section).to have_review_text @tweet_review
  expect(tweet_review_section.album_details.genre).to have_content @tweet_review.genre
  expect(tweet_review_section.album_player).to have_album @tweet_review.album_source_id
end

When(/^I create and sync the tweet review$/) do
  @create_review_page.create_and_sync
end

Then(/^I see the review was created and synced$/) do
  expect(@home_page).to have_flash_message 'Tweet updated with review and synced to spreadsheet'
end
