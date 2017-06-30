class Register < SitePrism::Page
  set_url '/users/sign_up'
  element :email_field, '#user_email'
  element :password_field, '#user_password'
  element :password_confirmation_field, '#user_password_confirmation'
  element :submit_button, '.form-actions .button'

  def sign_up(email, password)
    email_field.set email
    password_field.set password
    password_confirmation_field.set password
    submit_button.click
  end
end
