When(/^I download new JulySoundcheck tweets$/) do
  Archiver::TweetArchiver.archive
end

Then(/^I see the newly downloaded tweet$/) do
  expect(@home_page.tweets.first).to have_tweet_text Tweet.first
end
