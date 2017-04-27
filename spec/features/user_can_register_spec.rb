require 'rails_helper'

RSpec.feature 'user can register' do
  context 'with successful registration' do
    xscenario 'user sees successful flash message' do
      visit new_user_registration_path

      expect(page).to have_content('Sign up')

      expect do
        fill_in 'Email', with: 'jones@gmail.com'
        fill_in 'First name', with: 'Bob'
        fill_in 'Last name', with: 'Jones'
        fill_in 'Password', with: 'password'
        fill_in 'Password confirmation', with: 'password'
        click_button 'Sign up'
      end.to change { User.count }.by(1)

      expect(current_path).to eq root_path
      message = 'Welcome! You have signed up successfully. Login to get started.'
      expect(page).to have_content(message)
    end
  end

  context 'with unsuccessful registration' do
    xscenario 'user stays on the registration page and sees an error message' do
      visit new_user_registration_path

      expect(page).to have_content('Sign up')
      fill_in 'Email', with: 'jones@gmail.com'
      fill_in 'Last name', with: 'Jones'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password'
      click_button 'Sign up'

      expect(current_path).to eq new_user_registration_path
      expect(page).to have_content "first_name can't be blank"
    end
  end
end
