class Login < SitePrism::Page
  set_url '/users/sign_in'
  element :email_field, '#user_email'
  element :password_field, '#user_password'
  element :submit_button, '.form-actions .button'

  def sign_in(user, password)
    email_field.set user.email
    password_field.set password
    submit_button.click
  end
end
