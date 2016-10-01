Given(/^an unsynced review exists on the spreadsheet$/) do
  user = FactoryGirl.create(:user, :twitter_user, name: 'Alice Glass')
  tweet = FactoryGirl.create(:tweet, tweet_id: '781681048220536832', user: user)
  @unsaved_tweet_review = FactoryGirl.build(:tweet_review, user: user, tweet: tweet)
  SheetSync::Uploader.new(worksheet: @worksheet).upload(@unsaved_tweet_review)
end

When(/^I sync from Google spreadsheet$/) do
  SheetSync::Download::SheetReader.download
end

Then(/^I see the newly downloaded review$/) do
  expect(@home_page.tweet_reviews.first).to have_review_text TweetReview.first
end

Given(/^a synced review exists on the spreadsheet$/) do
  user = FactoryGirl.create(:user, :twitter_user, name: 'Alice Glass')
  tweet = FactoryGirl.create(:tweet, tweet_id: '781681048220536832', user: user)
  @tweet_review = FactoryGirl.create(:tweet_review, user: user, tweet: tweet, genre: nil)
  SheetSync::Uploader.new(worksheet: @worksheet).upload(@tweet_review)
end

Given(/^the synced review's genre is updated to "([^"]*)" on the spreadsheet$/) do |genre|
  @tweet_review.genre = genre
  SheetSync::Uploader.new(worksheet: @worksheet).upload(@tweet_review)
end

Then(/^I see the newly updated review's genre is "([^"]*)"$/) do |genre|
  expect(@home_page.tweet_reviews.first.album_details.genre).to have_content genre
end
