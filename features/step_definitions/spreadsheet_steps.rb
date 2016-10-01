Given(/^a JulySoundcheck Google spreadsheet exists$/) do
  @worksheet = SheetSync::Worksheet.new(sheet_key: ENV['TEST_GOOGLE_SHEET_KEY'])
  @worksheet.clear!
end

Then(/^the tweet review is added to the spreadsheet$/) do
  worksheet = SheetSync::Worksheet.new(sheet_key: ENV['TEST_GOOGLE_SHEET_KEY'])
  expect(SheetSync::ReviewRowFinder.new(worksheet).find(@tweet_review)).not_to be_nil
end

Given(/^my tweet review is synced to the spreadsheet$/) do
  worksheet = SheetSync::Worksheet.new(sheet_key: ENV['TEST_GOOGLE_SHEET_KEY'])
  SheetSync::Uploader.new(worksheet: worksheet).upload(@tweet_review)
end

Then(/^the tweet review was updated to the spreadsheet$/) do
  worksheet = SheetSync::Worksheet.new(sheet_key: ENV['TEST_GOOGLE_SHEET_KEY'])
  row = SheetSync::ReviewRowFinder.new(worksheet).find(@tweet_review)
  @tweet_review.reload
  expect(row.genre).to eq @tweet_review.genre
end
