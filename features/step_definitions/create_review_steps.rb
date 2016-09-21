Given(/^I have a JulySoundcheck tweet with rating$/) do
  @tweet = FactoryGirl.create(:tweet, :feed_item, :review, user: @user)
end

When(/^I edit the tweet$/) do
  @edit_review_page = @home_page.tweets.first.create_review
end

When(/^I add the review details to the tweet$/) do
  @edit_review_page.set_artist('WU LYF')
  @edit_review_page.set_album('Go Tell Fire To The Mountain')
  @edit_review_page.set_genre('Heavy Pop')
  @edit_review_page.set_listen_url('https://play.spotify.com/album/3YUCk9Q1vjWsZsTur93sQP')
end

When(/^I create the tweet review$/) do
  @edit_review_page.create
end

Then(/^I see the added review details to the tweet$/) do
  tweet_review_section = @home_page.tweet_reviews.first
  expect(tweet_review_section.user_name).to have_content @tweet.tweet_review.user.name
  expect(tweet_review_section.twitter_user_name).to have_content @tweet.tweet_review.user.twitter_screen_name
  expect(tweet_review_section).to have_profile_link_to @tweet.tweet_review.user
  expect(tweet_review_section).to be_reviewed_on @tweet.tweet_review.created_at
  expect(tweet_review_section.rating).to have_content @tweet.tweet_review.rating.to_s
  expect(tweet_review_section).to have_review_text @tweet.tweet_review
  expect(tweet_review_section.album_details.genre).to have_content @tweet.tweet_review.genre
  expect(tweet_review_section.album_player).to have_album @tweet.tweet_review.album_source_id
end
