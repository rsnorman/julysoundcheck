require './spec/factories'

# Capybara.register_driver :selenium do |app|
#   Capybara::Selenium::Driver.new(app, browser: :chrome)
# end
#
# Capybara.default_driver = :selenium

Around('@admin_twitter_user') do |_, block|
  VCR.use_cassette(:admin_twitter_user, allow_playback_repeats: true) { block.call }
end

Around('@twitter_user') do |_, block|
  VCR.use_cassette(:twitter_user, allow_playback_repeats: true) { block.call }
end
