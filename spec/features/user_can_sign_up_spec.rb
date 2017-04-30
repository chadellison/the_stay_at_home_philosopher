require 'rails_helper'

RSpec.feature 'user can sign up', js: true do
  context 'with valid credentials' do
    scenario 'user sees success message' do
      visit('localhost:3000')
      find('.signUpStatus').click

      within('.signUpForm') do
        find('.credentialFirstName').set Faker::Name.first_name
        find('.credentialLastName').set Faker::Name.first_name
        find('.credentialEmail').set(Faker::Number.number(20) + Faker::Internet.email)
        find('.credentialPassword').set Faker::Name.first_name
        click_button('Sign Up')
      end
    end
  end

  context 'with invalid credentials' do
    scenario 'user sees error message' do
      visit('localhost:3000')

      find('.signUpStatus').click
      within('.signUpForm') do
        find('.credentialFirstName').set Faker::Name.first_name
        find('.credentialLastName').set Faker::Name.first_name
        find('.credentialPassword').set Faker::Name.first_name
        click_button('Sign Up')
      end

      expect(page).to have_content "email can't be blank"
      click_button('OK, Got it!')
      click_button('Cancel')
    end
  end
end
