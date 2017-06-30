class TitleBarMenuSection < SitePrism::Section
  element :sign_in_menu_item, '#sign_in_link'
  element :profile_menu_item, '#profile_link'

  def click_sign_in
    sign_in_menu_item.click
  end

  def click_profile
    profile_menu_item.click
  end
end
