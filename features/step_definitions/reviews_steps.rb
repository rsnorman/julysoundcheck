When(/^I visit the home page$/) do
  @home_page = Home.new
  @home_page.load
end

Then(/^I see no reviews message$/) do
  expect(@home_page).to have_no_reviews
end

Given(/^a review exists$/) do
  @review = FactoryGirl.create(:review)
end

Given(/^a tweet review exists$/) do
  @tweet_review = FactoryGirl.create(:tweet_review)
end

Given(/^a tweet exists$/) do
  @tweet = FactoryGirl.create(:tweet, :feed_item)
end

Given(/^a review exists with no listen URL$/) do
  @limited_review = FactoryGirl.create(:review, listen_url: nil)
end

Given(/^a two-part tweet review exists$/) do
  @two_part_tweet_review = FactoryGirl.create(:tweet_review, :two_part)
end

Given(/^a tweet exists with a review$/) do
  @tweet_with_review = FactoryGirl.create(:tweet, :feed_item, :review)
end

Given(/^a tweet exists with a reply$/) do
  @tweet_with_reply = FactoryGirl.create(:tweet, :feed_item, :reply)
end

Then(/^I see the review$/) do
  review_section = @home_page.reviews.second
  expect(review_section.user_name).to have_content @review.user.name
  expect(review_section).to be_reviewed_on @review.reviewed_at
  expect(review_section.rating).to have_content @review.rating.to_s
  expect(review_section.review_text).to have_content @review.text
  expect(review_section.album_details.genre).to have_content @review.genre
  expect(review_section.album_player).to have_album @review.album_source_id
end

Then(/^I see the limited review$/) do
  review_section = @home_page.reviews.first
  expect(review_section.user_name).to have_content @limited_review.user.name
  expect(review_section).to be_reviewed_on @limited_review.reviewed_at
  expect(review_section.rating).to have_content @limited_review.rating.to_s
  expect(review_section.review_text).to have_content @limited_review.text
  expect(review_section.album_details.artist).to have_content @limited_review.artist
  expect(review_section.album_details.album).to have_content @limited_review.album
  expect(review_section.album_details.genre).to have_content @limited_review.genre
end

Then(/^I see the tweet review$/) do
  tweet_review_section = @home_page.tweet_reviews.second
  expect(tweet_review_section.user_name).to have_content @tweet_review.user.name
  expect(tweet_review_section.twitter_user_name).to have_content @tweet_review.user.twitter_screen_name
  expect(tweet_review_section).to have_profile_link_to @tweet_review.user
  expect(tweet_review_section).to be_reviewed_on @tweet_review.created_at
  expect(tweet_review_section.rating).to have_content @tweet_review.rating.to_s
  expect(tweet_review_section).to have_review_text @tweet_review
  expect(tweet_review_section.album_details.genre).to have_content @tweet_review.genre
  expect(tweet_review_section.album_player).to have_album @tweet_review.album_source_id
end

Then(/^I see the two-part tweet review$/) do
  tweet_review_section = @home_page.tweet_reviews.first
  expect(tweet_review_section.user_name).to have_content @two_part_tweet_review.user.name
  expect(tweet_review_section.twitter_user_name).to have_content @two_part_tweet_review.user.twitter_screen_name
  expect(tweet_review_section).to have_profile_link_to @two_part_tweet_review.user
  expect(tweet_review_section).to be_reviewed_on @two_part_tweet_review.created_at
  expect(tweet_review_section.rating).to have_content @two_part_tweet_review.rating.to_s
  expect(tweet_review_section).to have_review_text @two_part_tweet_review
  expect(tweet_review_section).to have_reply_text @two_part_tweet_review
  expect(tweet_review_section.album_details.genre).to have_content @two_part_tweet_review.genre
  expect(tweet_review_section.album_player).to have_album @two_part_tweet_review.album_source_id
end

Then(/^I see the tweet$/) do
  tweet_section = @home_page.tweets.third
  expect(tweet_section.user_name).to have_content @tweet.user.twitter_name
  expect(tweet_section.twitter_user_name).to have_content @tweet.user.twitter_screen_name
  expect(tweet_section).to have_profile_link_to @tweet.user
  expect(tweet_section).to be_tweeted_on @tweet.created_at
  expect(tweet_section).to have_text @tweet.text
  expect(tweet_section).to_not have_rating
end

Then(/^I see the tweet with a review$/) do
  tweet_section = @home_page.tweets.second
  expect(tweet_section.user_name).to have_content @tweet_with_review.user.twitter_name
  expect(tweet_section.twitter_user_name).to have_content @tweet_with_review.user.twitter_screen_name
  expect(tweet_section).to have_profile_link_to @tweet_with_review.user
  expect(tweet_section).to be_tweeted_on @tweet_with_review.created_at
  expect(tweet_section).to have_tweet_text @tweet_with_review
  expect(tweet_section.rating).to have_content '3+'
end

Then(/^I see the tweet with a reply$/) do
  tweet_section = @home_page.tweets.first
  expect(tweet_section.user_name).to have_content @tweet_with_reply.user.twitter_name
  expect(tweet_section.twitter_user_name).to have_content @tweet_with_reply.user.twitter_screen_name
  expect(tweet_section).to have_profile_link_to @tweet_with_reply.user
  expect(tweet_section).to be_tweeted_on @tweet_with_reply.created_at
  expect(tweet_section).to have_tweet_text @tweet_with_reply
  expect(tweet_section).to have_reply_text @tweet_with_reply
  expect(tweet_section).to_not have_rating
end
