require 'rails_helper'

RSpec.feature 'user can login' do
  context 'with successful login' do
    xscenario 'user sees successful flash message' do
      User.create(first_name: Faker::Name.first_name,
                  last_name:  Faker::Name.last_name,
                  email:      'jones@gmail.com',
                  password:   'password')

      visit new_user_session_path

      expect(page).to have_content('Log in')
      fill_in 'Email', with: 'jones@gmail.com'
      fill_in 'Password', with: 'password'
      click_button 'Log in'

      expect(current_path).to eq root_path
      expect(page).to have_content 'Signed in successfully'
    end
  end

  context 'with unsuccessful log in' do
    xscenario 'user sees successful flash message' do
      visit new_user_session_path

      expect(page).to have_content('Log in')
      fill_in 'Email', with: 'jones@gmail.com'
      fill_in 'Password', with: 'password'
      click_button 'Log in'

      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'Invalid Email or password.'
    end
  end
end
