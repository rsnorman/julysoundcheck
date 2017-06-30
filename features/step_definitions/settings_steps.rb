When(/^I visit the settings page$/) do
  @settings_page = Settings.new
  @settings_page.load
end

When(/^I update my name$/) do
  @settings_page.update_name('Ryan Norman')
end
