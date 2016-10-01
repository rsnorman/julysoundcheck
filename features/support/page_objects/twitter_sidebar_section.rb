class TwitterSidebarSection < SitePrism::Section
  element :sign_in_button, 'button'

  def login
    sign_in_button.click
  end
end
