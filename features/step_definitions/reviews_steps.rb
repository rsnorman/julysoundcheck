When(/^I visit the home page$/) do
  @home_page = Home.new
  @home_page.load
end

Then(/^I see no reviews message$/) do
  expect(@home_page).to have_no_reviews
end
