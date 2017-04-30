User.create(first_name: 'jones',
            last_name: 'bob', email:
            'jones@gmail.com',
            password: 'password')

15.times do |n|
  names = [Faker::StarWars.character, Faker::Superhero.name]

  User.create(first_name: names.sample.split.first,
              last_name: names.sample.split.first,
              email: Faker::Internet.email,
              password: Faker::Internet.password,
              about_me: Faker::StarWars.quotes.sample)
end

35.times do |n|
  body = [Faker::Hipster.paragraph(50), Faker::Lorem.paragraph(50)]
  titles = [Faker::StarWars.quotes.sample, Faker::Hipster.sentence(1)]

  post = Post.create(title: titles.sample,
                     body: body.sample,
                     user_id: User.all.sample.id)
  if n.even?
    post.comments.create(user_id: User.all.sample.id, body: Faker::StarWars.quotes.sample)
  end
end
