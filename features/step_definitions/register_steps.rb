When(/^I click to sign up$/) do
  @register_page = @login_page.go_to_sign_up
end

When(/^I register a new user$/) do
  @register_page.sign_up('rsnorman15@gmail.com', 'test1234')
  @home_page = Home.new
  @user = User.find_by(email: 'rsnorman15@gmail.com')
end
