require 'rails_helper'
require 'rake'

RSpec.feature 'user can visit home page', js: true do
  scenario 'user sees posts' do
    visit 'localhost:3000'
    expect(page).to have_content('The Stay at Home Philosopher')
    expect(page).to have_content('Browse and contribute to posts!')
    expect(page).to have_content('login')
    expect(page).to have_content('sign up')

    sleep 2
    first('.post').first('.postTitle').click
    expect(page).to have_content('Comments')
    click_button('All Posts')

    first('.rightArrow').click
    first('.leftArrow').click
  end
end
