require 'rails_helper'
require 'rake'

RSpec.feature 'user can visit home page', js: true do
  scenario 'user sees posts' do
    visit 'localhost:3000'
    expect(page).to have_content('The Stay at Home Philosopher')
    expect(page).to have_content('Browse and contribute to posts!')
    expect(page).to have_content('login')
    expect(page).to have_content('sign up')

    find('.signUpStatus').click

    within('.signUpForm') do
      expect(page).to have_content 'First Name'
      expect(page).to have_content 'Last Name'
      expect(page).to have_content 'Email'
      expect(page).to have_content 'Password'
      expect(page).to have_content 'Description'

      find('.credentialFirstName').set Faker::Name.first_name
      find('.credentialLastName').set Faker::Name.first_name
      find('.credentialPassword').set Faker::Name.first_name
      click_button('Sign Up')
    end

    expect(page).to have_content "email can't be blank"
    click_button('OK, Got it!')
    click_button('Cancel')

    sleep 2
    first('.post').first('.postTitle').click
    expect(page).to have_content('Comments')
    click_button('All Posts')

    first('.rightArrow').click
    first('.leftArrow').click
  end
end
