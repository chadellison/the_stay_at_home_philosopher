require 'rails_helper'

RSpec.describe Post, type: :model do
  it 'belongs to a user' do
    expect(Post.new).to respond_to(:user)
  end

  it 'has many comments' do
    expect(Post.new).to respond_to(:comments)
  end

  it 'validates the presence of a user_id' do
    title = Faker::Name.name
    body = Faker::Lorem.paragraph
    post = Post.new(title: title, body: body)
    expect(post.valid?).to be false

    post.user_id = Faker::Number.number(4)
    expect(post.valid?).to be true
  end

  it 'validates the presence of a title' do
    user_id = Faker::Number.number(4)
    body = Faker::Lorem.paragraph

    post = Post.new(user_id: user_id, body: body)

    expect(post.valid?).to be false

    post.title = Faker::Name.name
    expect(post.valid?).to be true
  end

  it 'validates the presence of a body' do
    title = Faker::Name.name
    user_id = Faker::Number.number(4)

    post = Post.new(title: title, user_id: user_id)

    expect(post.valid?).to be false

    post.body = Faker::Lorem.paragraph
    expect(post.valid?).to be true
  end

  context 'scopes' do
    describe 'post_order' do
      it 'orders the posts in descending order' do
        post1 = Post.create(title: Faker::Name.name,
                            body: Faker::Lorem.paragraph,
                            user_id: Faker::Number.number(4))

        post2 = Post.create(title: Faker::Name.name,
                            body: Faker::Lorem.paragraph,
                            user_id: Faker::Number.number(4))

        post3 = Post.create(title: Faker::Name.name,
                            body: Faker::Lorem.paragraph,
                            user_id: Faker::Number.number(4))

        expect(Post.post_order).to eq [post3, post2, post1]
      end
    end

    describe 'paginate' do
      context 'when no page number is passed in' do
        before do
          15.times do |n|
            Post.create(title: n.to_s,
                        body: "body number #{n}",
                        user_id: Faker::Number.number(4))
          end
        end

        it 'returns the posts without offsetting them' do
          expect(Post.paginate('').pluck(:title).first).to eq '0'
          expect(Post.paginate('').pluck(:body).last).to eq 'body number 14'
        end
      end

      context 'when a page number is passed in' do
        before do
          20.times do |n|
            if n == 10
              Post.create(title: '11th post',
                          body: "body number #{n}",
                          user_id: Faker::Number.number(8))
            elsif n == 19
              Post.create(title: '20th post',
                          body: "body number #{n}",
                          user_id: Faker::Number.number(8))
            else
              Post.create(title: n.to_s,
                          body: "body number #{n}",
                          user_id: Faker::Number.number(4))
            end
          end
        end

        it 'paginates the results' do
          expect(Post.paginate('2').pluck(:title).first).to eq '11th post'
          expect(Post.paginate('2').pluck(:title).last).to eq '20th post'
        end
      end
    end

    describe 'serialize_post' do
      let(:title) { Faker::Name.name }
      let(:body) { Faker::Lorem.paragraph }
      let(:first_name) { Faker::Name.first_name }
      let(:last_name) { Faker::Name.last_name }

      it 'returns a json api serialized hash with its author' do
        user = User.create(first_name: first_name,
                           last_name: last_name,
                           email: Faker::Internet.email,
                           password: Faker::Internet.password)

        post = user.posts.create(title: title,
                                 body: body)
        author = "#{first_name.capitalize} #{last_name.capitalize}"

        expect(post.serialize_post[:attributes][:title]).to eq title
        expect(post.serialize_post[:attributes][:body]).to eq body
        expect(post.serialize_post[:relationships][:author])
          .to eq author
      end
    end

    describe 'serialize_comments' do
      let(:user1) do
        User.create(first_name: 'jones',
                    last_name: 'bob',
                    email: Faker::Internet.email,
                    password: Faker::Internet.password)
      end

      let(:user2) do
        User.create(first_name: 'foo',
                    last_name: 'bar',
                    email: Faker::Internet.email,
                    password: Faker::Internet.password)
      end

      let(:post) do
        user1.posts.create(title: Faker::Name.name,
                           body: Faker::Lorem.paragraph)
      end

      let(:comment_body1) { Faker::Lorem.paragraph }
      let(:comment_body2) { Faker::Lorem.paragraph }

      let!(:comment1) do
        post.comments.create(body: comment_body1, user_id: user1.id)
      end

      let!(:comment2) do
        post.comments.create(body: comment_body2, user_id: user2.id)
      end

      it 'returns an array of comments with their respective authors' do
        created_at1 = comment1.created_at.to_date
        created_at2 = comment2.created_at.to_date

        result = post.serialize_comments
        expect(result.first).to eq(id: comment1.id,
                                   type: 'comment',
                                   attributes: {
                                     body: comment_body1,
                                     created_at: created_at1,
                                     updated_at: created_at1
                                   },
                                   relationships: { author: 'Jones Bob' })
        expect(result.last).to eq(id: comment2.id,
                                  type: 'comment',
                                  attributes: {
                                    body: comment_body2,
                                    created_at: created_at2,
                                    updated_at: created_at2
                                  },
                                  relationships: { author: 'Foo Bar' })
      end
    end

    context 'class methods' do
      describe 'include_associations' do
        context 'with users' do
          before do
            5.times do |n|
              user = User.create(first_name: "first#{n}",
                                 last_name: "last#{n}",
                                 email: Faker::Internet.email,
                                 password: Faker::Internet.password)
              user.posts.create(title: n.to_s, body: "body number #{n}")
            end
          end

          it 'returns a hash matching the json api spec' do
            result = Post.include_associations(Post.all)[:data]
            expect(result.first[:attributes][:title]).to eq '0'
            expect(result.first[:relationships][:author]).to eq 'First0 Last0'
            expect(result.last[:attributes][:body]).to eq 'body number 4'
            expect(result.last[:relationships][:author]).to eq 'First4 Last4'
          end
        end

        context 'with users and comments present' do
          let(:comment_body1) { Faker::Lorem.paragraph }
          let(:comment_body2) { Faker::Lorem.paragraph }
          let(:comment_body3) { Faker::Lorem.paragraph }
          let(:user1) do
            User.create(first_name: 'jones',
                        last_name: 'bob',
                        email: Faker::Internet.email,
                        password: Faker::Internet.password)
          end

          let(:user2) do
            User.create(first_name: 'foo',
                        last_name: 'bar',
                        email: Faker::Internet.email,
                        password: Faker::Internet.password)
          end

          before do
            post1 = user1.posts.create(title: 'title1', body: 'body1')
            post2 = user1.posts.create(title: 'title2', body: 'body2')
            post3 = user1.posts.create(title: 'title3', body: 'body3')

            post1.comments.create(
              body: comment_body1, user_id: user1.id
            )
            post1.comments.create(
              body: comment_body2, user_id: user1.id
            )
            post3.comments.create(
              body: comment_body3, user_id: user2.id
            )
          end

          it 'returns a json api serialed hash with associated comments' do
            result = Post.include_associations(Post.all)[:data]
            expect(result.first[:relationships][:comments].count).to eq 2
            expect(result.last[:relationships][:comments].count).to eq 1
            expect(result.first[:relationships][:comments].second[:relationships][:author])
              .to eq 'Jones Bob'
            expect(result.last[:relationships][:comments].first[:relationships][:author])
              .to eq 'Foo Bar'
          end
        end
      end
    end
  end
end
