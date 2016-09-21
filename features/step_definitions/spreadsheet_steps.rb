Given(/^a JulySoundcheck Google spreadsheet exists$/) do
  @worksheet = SheetSync::Worksheet.new(sheet_key: ENV['TEST_GOOGLE_SHEET_KEY'])
end

Then(/^the tweet review is added to the spreadsheet$/) do
  expect(SheetSync::ReviewRowFinder.new(@worksheet).find(@tweet_review)).not_to be_nil
end

Given(/^my tweet review is synced to the spreadsheet$/) do
  SheetSync::Uploader.new(worksheet: @worksheet).upload(@tweet_review)
end

Then(/^the tweet review was updated to the spreadsheet$/) do
  row = SheetSync::ReviewRowFinder.new(@worksheet).find(@tweet_review)
  expect(row.genre).to eq @tweet_review.genre
end
