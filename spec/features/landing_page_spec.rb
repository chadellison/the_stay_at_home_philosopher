require 'rails_helper'

# This spec is here primarily because the requirements call for one feature test
# capybara/rspec. Since this app is just a backend rails api the feature test
# pings its corresponding react app 'the-stay-home-philosopher-client'. Also,
# since this environment is not able to reset the db (i.e. delete a user after
# creating one), this test does not create any resources.
RSpec.feature 'user can visit home page', js: true do
  scenario 'user sees posts' do
    visit 'https://the-stay-at-home-philosopher.herokuapp.com/'
    expect(page).to have_content('The Stay at Home Philosopher')
    expect(page).to have_content('Browse and contribute to posts!')
    expect(page).to have_content('login')
    expect(page).to have_content('sign up')

    find('.loginStatus').click
    within('.credentialForm') do
      expect(page).to have_content('Email')
      expect(page).to have_content('Password')
      find('.credentialEmail').set Faker::Internet.email
      find('.credentialPassword').set Faker::Internet.password(8)
      click_button('Login')
    end

    expect(page).to have_content 'Invalid Credentials'
    click_button('OK, Got it!')

    within('.credentialForm') do
      click_button('Cancel')
    end

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
    first('.postTitle').click
    expect(page).to have_content('Comments')
    click_button('All Posts')

    first('.rightArrow').click
    first('.leftArrow').click
  end
end
