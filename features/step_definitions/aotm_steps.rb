When(/^I set as Album of the Month$/) do
  @edit_review_page.set_as_album_of_the_month
end

Then(/^I see the tweet review is Album of the Month$/) do
  expect(@home_page.tweet_reviews.first).to have_aotm_badge
end

Given(/^I have an Album of the Month review$/) do
  @review = FactoryGirl.create(:review, album_of_the_month: true)
end

Then(/^I only see Album of the Month reviews$/) do
  @home_page.reviews.each do |tweet_review|
    expect(tweet_review).to have_aotm_badge
  end
end
