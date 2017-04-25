require 'rails_helper'

describe Api::V1::PostsController do
  describe 'index' do
    it 'returns a 200 status' do
      get :index, format: :json
      expect(response.status).to eq 200
    end

    it 'returns all of the posts with their authors' do
      user = User.create(first_name: Faker::Name.first_name,
                         last_name: Faker::Name.last_name,
                         email: Faker::Internet.email,
                         password: Faker::Internet.password)
      3.times do |n|
        user.posts.create(title: "title#{n}", body: "body#{n}")
      end

      get :index, format: :json
      parsed_response = JSON.parse(response.body)['data']
      expect(parsed_response.count).to eq 3
      expect(parsed_response.first['attributes']['title']).to eq 'title2'
      expect(parsed_response.last['attributes']['body']).to eq 'body0'
      expect(parsed_response.last['relationships']['author']).to eq user.full_name
    end
  end

  describe 'create' do
    let(:title) { Faker::Name.name }
    let(:body) { Faker::Lorem.paragraph }
    let(:user) do
      User.create(first_name: Faker::Name.first_name,
                  last_name:  Faker::Name.last_name,
                  email:      Faker::Internet.email,
                  password:   Faker::Internet.password)
    end

    context 'with a valid post' do
      before do
        allow(controller).to receive(:authenticate_user!).and_return(user)
        allow(controller).to receive(:current_user).and_return(user)
      end

      it 'returns a 201 status and the resource' do
        post :create, post: { title: title, body: body }, format: :json
        expect(response.status).to eq 201
        expect(JSON.parse(response.body)["title"]).to eq title
        expect(JSON.parse(response.body)["body"]).to eq body
        expect(JSON.parse(response.body)["user_id"]).to eq user.id
      end

      it 'creates a new post associated with the current user' do
        expect do
          post :create, post: { title: title, body: body }, format: :json
        end.to change { Post.count && user.posts.count }.by(1)

        expect(user.posts.last.title).to eq title
        expect(user.posts.last.body).to eq body
      end
    end

    context 'with an invalid post' do
      before do
        allow(controller).to receive(:authenticate_user!).and_return(user)
        allow(controller).to receive(:current_user).and_return(user)
      end

      it 'returns a 400 status' do
        post :create, post: { title: "", body: body }, format: :json
        expect(response.status).to eq 400
      end

      it 'does not create a post' do
        expect do
          post :create, post: { title: "", body: body }, format: :json
        end.not_to change { Post.count && user.posts.count }
      end

      it 'returns an error' do
        post :create, post: { title: title, body: "" }, format: :json
        expect(JSON.parse(response.body)["errors"]).to eq "body can't be blank"
      end
    end

    context 'when a user is not logged in' do
      it 'returns an error message' do
        result = "You need to sign in or sign up before continuing."

        post :create, post: { title: title, body: body }, format: :json
        expect(JSON.parse(response.body)["error"]).to eq result
      end

      it 'renders a 401 status' do
        post :create, post: { title: title, body: body }, format: :json
        expect(response.status).to eq 401
      end
    end
  end
end
