require './spec/factories'

include Warden::Test::Helpers
Warden.test_mode!

# Capybara.register_driver :selenium do |app|
#   Capybara::Selenium::Driver.new(app, browser: :chrome)
# end

# Capybara.default_driver = :selenium

Around('@admin_twitter_user') do |_, block|
  VCR.use_cassette(:admin_twitter_user, allow_playback_repeats: true) { block.call }
end

Around('@twitter_user') do |_, block|
  VCR.use_cassette(:twitter_user, allow_playback_repeats: true) { block.call }
end

Around('@tweet_search') do |_, block|
  VCR.use_cassette(:julysoundcheck_tweet_search, allow_playback_repeats: true) { block.call }
end

After do
  Warden.test_reset!
end
