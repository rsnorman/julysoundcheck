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
  FactoryGirl.create(:tweet_review)
end

Given(/^a tweet exists$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I see the review$/) do
  expect(@home_page.reviews.first.user_name).to have_content @review.user.name
end

Then(/^I see the tweet review$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I see the tweet$/) do
  pending # Write code here that turns the phrase above into concrete actions
end
