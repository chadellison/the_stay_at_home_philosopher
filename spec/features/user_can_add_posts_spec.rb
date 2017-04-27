RSpec.feature 'user can add posts' do
  context 'successfully' do
    let(:first_name) { Faker::Name.first_name }
    let(:last_name) { Faker::Name.last_name }
    let(:email) { Faker::Internet.email }
    let(:password) { Faker::Internet.password }

    xscenario 'user sees new post' do
      user = User.create(first_name: first_name, last_name: last_name,
                         email: email, password: password)
      login_as(user, scope: :user)

      visit root_path
      expect(page).to have_button('Add Post')
    end
  end

  context 'unsuccessfully' do
    xscenario 'user sees error message' do
    end
  end
end
