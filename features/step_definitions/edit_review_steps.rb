Given(/^I have a JulySoundcheck tweet review$/) do
  tweet = FactoryGirl.create(:tweet, tweet_id: '987654321', user: @user)
  @tweet_review = FactoryGirl.create(:tweet_review, user: @user, tweet: tweet)
end

When(/^I edit the tweet review$/) do
  @edit_review_page = @home_page.tweet_reviews.first.edit_review
end

When(/^I set the genre to "([^"]*)"$/) do |genre|
  @edit_review_page.set_genre(genre)
end

When(/^I save the tweet review$/) do
  @edit_review_page.update
end

Then(/^I see the tweet review with a genre "([^"]*)"$/) do |genre|
  tweet_review_section = @home_page.tweet_reviews.first
  expect(tweet_review_section.album_details.genre).to have_content genre
end

When(/^I save and sync the tweet review$/) do
  @edit_review_page.update_and_sync
end

Then(/^I see the review was updated$/) do
  expect(@home_page).to have_flash_message 'Tweet updated with review'
end

Then(/^I see the review was updated and synced$/) do
  expect(@home_page).to have_flash_message 'Tweet updated with review and synced to spreadsheet'
end
