class TwitterLogin < SitePrism::Page
  element :sign_in_button, 'input[type="submit"]'

  def fill_in_login_details
    fill_in 'Username or email', with: ENV['TEST_TWITTER_SCREEN_NAME']
    fill_in 'Password', with: ENV['TEST_TWITTER_PASSWORD']
  end

  def submit
    click_button 'Sign In'
    TwitterRedirect.new
  end
end
