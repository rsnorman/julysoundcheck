When(/^I click the Sign In button$/) do
  @login_page = @home_page.go_sign_in
end

When(/^I login with my credentials$/) do
  @login_page.sign_in(@user, 'test1234')
  @home_page = Home.new
end

When(/^I click the profile button$/) do
  @profile_page = @home_page.go_to_profile
end

Given(/^a user exists for me$/) do
  @user = FactoryGirl.create(:user, email: 'rsnorman15@gmail.com',
                                    password: 'test1234',
                                    name: 'Ryan Norman')
end
