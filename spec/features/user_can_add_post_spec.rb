RSpec.feature 'user can add post', js: true do
  context 'with successful data' do
    let(:title) { Faker::StarWars.droid.downcase }
    let(:body) { Faker::Lorem.paragraph(30).downcase }
    let(:result_body) { "#{body[0...100].capitalize}..." }

    scenario 'user sees confirmation message and added post' do
      visit 'localhost:3000'

      find('.loginStatus').click
      within('.credentialForm') do
        find('.credentialEmail').set "jones@gmail.com"
        find('.credentialPassword').set "password"
        click_button('Login')
      end

      click_button('Add Post')
      find('.addPostTitle').set(title)
      find('.addPostBody').set(body)
      find('.addPostSubmit').click

      expect(page).to have_content('Your post has been added!')
      click_button("OK, Got it!")

      expect(page).to have_content(title)
      expect(page).to have_content(result_body)
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

        click_button('Add Post')
        find('.addPostTitle').set(title)
        find('.addPostSubmit').click

        expect(page).to have_content("body can't be blank")
        click_button("OK, Got it!")
      end
    end
  end
end
