Given(/^a user exists with a Twitter account$/) do
  @user = FactoryGirl.create(:user, :twitter_user)
end

Given(/^the user has a review$/) do
  @review = FactoryGirl.create(:review, user: @user, rating: 5)
end

Given(/^the user has a tweet review$/) do
  @tweet_review = FactoryGirl.create(:tweet_review, user: @user, rating: 11)
end

Given(/^the user has a tweet$/) do
  @tweet = FactoryGirl.create(:tweet, :feed_item, user: @user)
end

When(/^I visit the user's profile page$/) do
  @profile_page = Profile.new
  @profile_page.load(name: @user.twitter_screen_name || @user.slug)
end

Then(/^I see their recent reviews and tweets$/) do
  expect(@profile_page.reviews.first).to have_review_text @review.text
  expect(@profile_page.tweet_reviews.first).to have_review_text @tweet_review
  expect(@profile_page.tweets.first).to have_tweet_text @tweet
end

Then(/^I see their recent reviews$/) do
  expect(@profile_page.reviews.first).to have_review_text @review.text
end

Then(/^I see their stats$/) do
  expect(@profile_page.reviewer_stats.total_reviews_stat).to have_content '2'
  expect(@profile_page.reviewer_stats.average_rating_stat).to have_content '2'
  expect(@profile_page.reviewer_stats.longest_streak_stat).to have_content '1'
end

Then(/^I see a link to their Twitter profile$/) do
  expect(@profile_page.twitter_profile_link['href'])
    .to eq "https://www.twitter.com/#{@user.twitter_screen_name}"
end

Given(/^a user exists without a Twitter account$/) do
  @user = FactoryGirl.create(:user)
end

Given(/^a review exists from another user$/) do
  @other_review = FactoryGirl.create(:review)
end

Then(/^I don't see a link to their Twitter profile$/) do
  expect(@profile_page).not_to have_twitter_profile_link
end

Then(/^I see they have "([^"]*)" review[s]?$/) do |total_reviews|
  expect(@profile_page.reviewer_stats.total_reviews_stat)
    .to have_content total_reviews
end

Then(/^I see they have an average rating of "([^"]*)"$/) do |average_rating|
  expect(@profile_page.reviewer_stats.average_rating_stat)
    .to have_content average_rating
end

Then(/^I see they have a review streak of "([^"]*)"$/) do |streak_days|
  expect(@profile_page.reviewer_stats.longest_streak_stat)
    .to have_content "#{streak_days} days"
end

When(/^I visit a profile for a non\-user$/) do
  @profile_page = Profile.new
  @profile_page.load(name: SecureRandom.uuid[0..7])
end

Then(/^I see no recent reviews for the user$/) do
  expect(page).to have_content 'No JulySoundcheck reviews yet'
end

Then(/^I don't see other user's reviews$/) do
  expect(@profile_page).not_to have_css "#review_#{@other_review.id}"
end

Given(/^the user has second page of feed items$/) do
  26.times do
    FactoryGirl.create(:tweet, :feed_item, user: @user)
  end
end

When(/^I click "([^"]*)" in the profile pagination links$/) do |page_number|
  @profile_page.pagination.go_to_page(page_number)
  @profile_page = Profile.new
end

Then(/^I see the second page of user's tweets$/) do
  expect(@profile_page).to have_css '#tweet_1'
end

Then(/^I see my profile page$/) do
  expect(@profile_page).to have_user(@user.name || @user.twitter_screen_name || @user.email)
end

Then(/^I see my profile page with name "([^"]*)"$/) do |name|
  expect(@profile_page).to have_user(name)
end
