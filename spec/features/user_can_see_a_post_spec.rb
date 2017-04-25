require 'rails_helper'

RSpec.feature 'user can see a post' do
  let(:title) { Faker::Name.name }
  let(:body) { Faker::Lorem.paragraph }
  let(:user) do
    User.create(first_name: Faker::Name.first_name,
                last_name:  Faker::Name.last_name,
                email:      Faker::Internet.email,
                password:   Faker::Internet.password)
  end

  scenario 'user sees a post' do
    post = user.posts.create(title: title, body: body)
    visit post_path(post.id)

    expect(page).to have_content(post.title)
    expect(page).to have_content(post.body)
    expect(page).to have_content('Author: ' + post.user.full_name)
  end
end
