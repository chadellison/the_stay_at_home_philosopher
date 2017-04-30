require 'rails_helper'

RSpec.feature 'user can login', js: true do
  context 'with valid credentials' do
    scenario 'user sees add Post Button' do
      visit 'localhost:3000'
      expect(page).not_to have_content 'Add Post'

      find('.loginStatus').click
      within('.credentialForm') do
        find('.credentialEmail').set "jones@gmail.com"
        find('.credentialPassword').set "password"
        click_button('Login')
      end

      expect(page).not_to have_content('login')
      expect(page).not_to have_content('Sign Up')

      expect(page).to have_content 'Add Post'
      find('.logout').click
    end
  end


  scenario 'user sees button to add comment' do
    visit 'https://the-stay-at-home-philosopher.herokuapp.com/'

    find('.loginStatus').click
    within('.credentialForm') do
      find('.credentialEmail').set "jones@gmail.com"
      find('.credentialPassword').set "password"
      click_button('Login')
    end

    sleep 2
    first('.post').first('.postTitle').click

    expect(page).to have_button('Leave a Comment')
    find('.logout').click
  end

  context 'with invalid credentials' do
    scenario 'users sees error and is not logged in' do
      visit 'https://the-stay-at-home-philosopher.herokuapp.com/'
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
    end
  end
end
