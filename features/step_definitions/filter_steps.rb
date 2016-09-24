Given(/^a review exists with a (\d+) rating$/) do |score|
  FactoryGirl.create(:review, rating: Rating.from_score(score).value)
end

Given(/^a review exists with a (\d+)\- rating$/) do |score|
  FactoryGirl.create(:review, rating: Rating.from_score("#{score}+").value)
end

Given(/^a review exists with a (\d+)\+ rating$/) do |score|
  FactoryGirl.create(:review, rating: Rating.from_score("#{score}-").value)
end

When(/^I filter "([^"]*)" reviews$/) do |score_group|
  @home_page = @home_page.filter.select(score_group)
end

Then(/^I only see reviews with "([^"]*)" ratings$/) do |score_group|
  score = Rating::SCORE_GROUPS.key(score_group)
  @home_page.reviews.each do |review|
    expect(review.rating).to have_text score
  end
end

Then(/^I see all the reviews$/) do
  TweetReview.find_each do |review|
    expect(page).to have_css "#review_#{review.id}"
  end
end

When(/^I clear the filter$/) do
  @home_page = @home_page.filter.select('None')
end
