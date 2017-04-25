require 'rails_helper'

describe Api::V1::CommentsController do
  describe 'index' do
    it 'returns a 200 status' do
      get :index, format: :json
      expect(response.status).to eq 200
    end

    it 'returns all of the comments with their authors' do
      user = User.create(first_name: Faker::Name.first_name,
                         last_name: Faker::Name.last_name,
                         email: Faker::Internet.email,
                         password: Faker::Internet.password)

      user2 = User.create(first_name: Faker::Name.first_name,
                          last_name: Faker::Name.last_name,
                          email: Faker::Internet.email,
                          password: Faker::Internet.password)
      3.times do |n|
        if n.even?
          post = user.posts.create(title: Faker::Name.name,
                                   body: Faker::Lorem.paragraph)
          user.comments.create(post_id: post.id, body: "body#{n}")
        else
          post = user2.posts.create(title: Faker::Name.name,
                                    body: Faker::Lorem.paragraph)
          user2.comments.create(post_id: post.id, body: "body#{n}")
        end
      end

      get :index, format: :json
      parsed_response = JSON.parse(response.body)['data']
      expect(parsed_response.count).to eq 3
      expect(parsed_response.first['attributes']['body']).to eq 'body0'
      expect(parsed_response.first['relationships']['author']).to eq user.full_name
      expect(parsed_response[1]['attributes']['body']).to eq 'body1'
      expect(parsed_response[1]['relationships']['author']).to eq user2.full_name
    end
  end

  describe 'create' do
    let(:body) { Faker::Lorem.paragraph }
    let(:user) do
      User.create(first_name: Faker::Name.first_name,
                  last_name:  Faker::Name.last_name,
                  email:      Faker::Internet.email,
                  password:   Faker::Internet.password)
    end

    let(:current_post) do
      user.posts.create(title: Faker::Name.name, body: Faker::Lorem.paragraph)
    end

    context 'with a valid comment' do
      let(:comment_body) { Faker::Lorem.paragraph }
      before do
        allow(controller).to receive(:authenticate_user!).and_return(user)
        allow(controller).to receive(:current_user).and_return(user)
      end

      it 'returns a 201 status and the resource' do
        post :create, comment: { body: comment_body, post_id: current_post.id },
                      format: :json
        expect(response.status).to eq 201
        expect(JSON.parse(response.body)['body']).to eq comment_body
        expect(JSON.parse(response.body)['user_id']).to eq user.id
        expect(JSON.parse(response.body)['post_id']).to eq current_post.id
      end

      it 'creates a new comment associated with the current user and post' do
        expect do
          post :create, comment: { body: comment_body, post_id: current_post.id }, format: :json
        end.to change{
          Comment.count && current_post.comments.count && user.comments.count }
        .by(1)

        expect(user.comments.last.body).to eq comment_body
        expect(current_post.comments.last.body).to eq comment_body
      end
    end

    context 'with an invalid comment' do
      before do
        allow(controller).to receive(:authenticate_user!).and_return(user)
        allow(controller).to receive(:current_user).and_return(user)
      end

      it 'returns a 400 status' do
        post :create, comment: { body: '', post_id: current_post.id }, format: :json
        expect(response.status).to eq 400
      end

      it 'does not create a comment' do
        expect do
          post :create, comment: { body: '', post_id: current_post.id }, format: :json
        end.not_to change { Comment.count && current_post.comments.count }
      end

      it 'returns an error' do
        post :create, comment: { body: '', post_id: current_post.id }, format: :json
        expect(JSON.parse(response.body)['errors']).to eq "body can't be blank"
      end
    end

    context 'when a user is not logged in' do
      it 'returns an error message' do
        result = 'You need to sign in or sign up before continuing.'

        post :create, comment: { body: body, post_id: current_post.id }, format: :json
        expect(JSON.parse(response.body)['error']).to eq result
      end

      it 'renders a 401 status' do
        post :create, comment: { body: body, post_id: current_post.id }, format: :json
        expect(response.status).to eq 401
      end
    end
  end
end
