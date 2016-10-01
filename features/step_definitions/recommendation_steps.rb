Given(/^a review exists that was recommended by someone else$/) do
  @recommender = FactoryGirl.create(:user, twitter_screen_name: 'JustinVernon',
                                           name: 'Justin Vernon')
  @review = FactoryGirl.create(:review)
  @review.update(
    text: "#{@review.text}… recommended by @#{@recommender.twitter_screen_name}"
  )
end

Given(/^a tweet review exists that was recommended by someone else$/) do
  @recommender = FactoryGirl.create(:user, twitter_screen_name: 'JustinVernon',
                                           name: 'Justin Vernon')
  @tweet_review = FactoryGirl.create(:tweet_review)
  @tweet_review.tweet.update(
    text: "#{@tweet_review.tweet.text}… recommended by @#{@recommender.twitter_screen_name}"
  )
end

Given(/^a tweet exists that was recommended by someone else$/) do
  @recommender = FactoryGirl.create(:user, twitter_screen_name: 'JustinVernon',
                                           name: 'Justin Vernon')
  @tweet = FactoryGirl.create(:tweet, :feed_item)
  @tweet.update(
    text: "#{@tweet.text}… recommended by @#{@recommender.twitter_screen_name}"
  )
end

When(/^I click the the recommender's screen name on the review$/) do
  @home_page.reviews.first.recommender.click
  @profile_page = Profile.new
end

Then(/^I see the recommender's profile$/) do
  expect(@profile_page).to have_content 'Justin Vernon'
end

When(/^I click the the recommender's screen name on the tweet review$/) do
  @home_page.tweet_reviews.first.recommender.click
  @profile_page = Profile.new
end

When(/^I click the the recommender's screen name on the tweet$/) do
  @home_page.tweets.first.recommender.click
  @profile_page = Profile.new
end
