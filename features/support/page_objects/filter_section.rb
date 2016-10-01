class FilterSection < SitePrism::Section
  element :filter_button, '.button'

  def select(score_group)
    filter_button.click
    click_link score_group
    Home.new
  end
end
