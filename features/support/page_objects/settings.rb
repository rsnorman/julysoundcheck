class Settings < SitePrism::Page
  set_url '/settings'
  element :name_field, '#user_name'
  element :submit_button, 'input.button'

  def update_name(name)
    name_field.set name
    submit_button.click
  end
end
