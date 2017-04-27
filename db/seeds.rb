# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(first_name: 'jones', last_name: 'bob', email: 'jones@gmail.com', password: 'password')

5.times do |n|
  User.create(first_name: Faker::StarWars.character,
              last_name: Faker::StarWars.character,
              email: Faker::Internet.email,
              password: Faker::Internet.password,
              about_me: Faker::StarWars.quotes.sample)
end

30.times do |n|
  post = Post.create(title: Faker::StarWars.quotes.sample,
                     body: Faker::Lorem.paragraph(50),
                     user_id: User.all.sample.id)
  if n % 3 == 0
    post.comments.create(user_id: User.all.sample.id, body: Faker::StarWars.quotes.sample)
  end
end
