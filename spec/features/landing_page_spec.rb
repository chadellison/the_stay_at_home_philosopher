require 'rails_helper'

RSpec.feature 'user can visit home page' do
  let(:title) { Faker::Name.name }
  let(:body) { Faker::Lorem.paragraph }
  let(:user1) do
    User.create(first_name: Faker::Name.first_name,
                last_name:  Faker::Name.last_name,
                email:      Faker::Internet.email,
                password:   Faker::Internet.password)
  end

  let(:user2) do
    User.create(first_name: Faker::Name.first_name,
                last_name:  Faker::Name.last_name,
                email:      Faker::Internet.email,
                password:   Faker::Internet.password)
  end

  scenario 'user sees posts' do
    post1 = user1.posts.create(title: title, user_id: user1.id, body: body)
    post2 = user2.posts.create(title: title, user_id: user2.id, body: body)
    post3 = user1.posts.create(title: title, user_id: user1.id, body: body)

    visit root_path

    expect(page).to have_content('The Stay at Home Philosopher')
    expect(page).to have_content('Posts')
    expect(page).to have_content(post3.title)
    expect(page).to have_content("Author: #{user1.first_name} #{user1.last_name}")
    expect(page).to have_content(post2.title)
    expect(page).to have_content("Author: #{user2.first_name} #{user2.last_name}")
    expect(page).to have_content(post1.title)
    expect(page).to have_content("Author: #{user1.first_name} #{user1.last_name}")
  end
end
