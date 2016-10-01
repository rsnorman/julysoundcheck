class TwitterRedirect < SitePrism::Page
  def redirect
    click_link 'click here to continue'
  end
end
