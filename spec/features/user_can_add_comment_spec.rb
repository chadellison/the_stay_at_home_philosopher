RSpec.feature 'user can add comment', js: true do
  context 'with successful data' do
    let(:comment) { Faker::Lorem.sentence.downcase }

    scenario 'user sees confirmation message and added post' do
      visit 'localhost:3000'

      find('.loginStatus').click
      within('.credentialForm') do
        find('.credentialEmail').set "jones@gmail.com"
        find('.credentialPassword').set "password"
        click_button('Login')
      end

      sleep 2
      first('.post').first('.postTitle').click

      click_button('Leave a Comment')
      find('.commentFormBody').set(comment)
      click_button('Submit')
      expect(page).to have_content('Your comment has been added!')
      click_button("OK, Got it!")
      expect(page).to have_content(comment)
      expect(page).to have_content("Author: Jones Bob")
      find('.logout').click
    end

    context 'with unsuccessful data' do
      scenario 'users sees error message' do
        visit 'localhost:3000'

        find('.loginStatus').click
        within('.credentialForm') do
          find('.credentialEmail').set "jones@gmail.com"
          find('.credentialPassword').set "password"
          click_button('Login')
        end

        sleep 2
        first('.post').first('.postTitle').click

        click_button('Leave a Comment')
        click_button('Submit')

        expect(page).to have_content("body can't be blank")
        click_button("OK, Got it!")
        find('.logout').click
      end
    end
  end
end
