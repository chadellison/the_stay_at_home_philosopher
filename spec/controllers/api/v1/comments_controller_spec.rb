require 'rails_helper'

describe Api::V1::CommentsController do
  describe 'index' do
    let(:user) do
      User.create(first_name: Faker::Name.first_name,
                  last_name: Faker::Name.last_name,
                  email: Faker::Internet.email,
                  password: Faker::Internet.password)
    end

    let(:post) do
      user.posts.create(title: Faker::Name.name, body: Faker::Lorem.paragraph)
    end

    before do
      3.times do |n|
        user.comments.create(body: "body#{n}", post_id: post.id)
      end
    end

    it 'returns a 200 status' do
      get :index, post_id: post.id, format: :json
      expect(response.status).to eq 200
    end

    it 'returns all of the comments associated with a post and their authors' do
      other_post = user.posts.create(title: Faker::Name.name,
                                     body: Faker::Lorem.paragraph)
      other_post.comments.create(body: Faker::Lorem.paragraph, user_id: user.id)

      get :index, post_id: post.id, format: :json
      parsed_response = JSON.parse(response.body)['data']
      expect(parsed_response.count).to eq 3
      expect(parsed_response.first['attributes']['body']).to eq 'body0'
      expect(parsed_response.last['attributes']['body']).to eq 'body2'
      expect(parsed_response.last['relationships']['author']['data']['name'])
        .to eq user.full_name
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

    let(:different_user) do
      User.create(first_name: Faker::Name.first_name,
                  last_name: Faker::Name.last_name,
                  email: Faker::Internet.email,
                  password: Faker::Internet.password)
    end

    let(:current_post) do
      user.posts.create(title: Faker::Name.name, body: Faker::Lorem.paragraph)
    end

    context 'with a valid comment' do
      let(:comment_body) { Faker::Lorem.paragraph }

      before do
        allow(controller).to receive(:authenticate_with_token)
          .and_return(different_user)
        controller.instance_variable_set(:@user, different_user)
      end

      it 'returns a 201 status and the resource' do
        post :create, comment: { body: comment_body, post_id: current_post.id },
                      format: :json
        expect(response.status).to eq 201

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['attributes']['body']).to eq comment_body
        expect(parsed_response['relationships']['author']['data']['name'])
          .to eq different_user.full_name
      end

      it 'creates a new comment associated with the current user and post' do
        expect do
          post :create, comment: { body: comment_body, post_id: current_post.id }, format: :json
        end.to change {
          Comment.count &&
            current_post.comments.count &&
            different_user.comments.count
        }.by(1)

        result = JSON.parse(response.body)
        expect(result['relationships']['author']['data']['name'])
          .to eq different_user.full_name
        expect(different_user.comments.last.body).to eq comment_body
        expect(current_post.comments.last.body).to eq comment_body
      end
    end

    context 'with an invalid comment' do
      before do
        allow(controller).to receive(:authenticate_with_token).and_return(user)
        controller.instance_variable_set(:@user, user)
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

    context 'when a user is not authenticated' do
      it 'returns an error message' do
        result = 'Invalid Credentials'

        post :create, comment: { body: body, post_id: current_post.id }, format: :json
        expect(JSON.parse(response.body)['errors']).to eq result
      end

      it 'renders a 401 status' do
        post :create, comment: { body: body, post_id: current_post.id }, format: :json
        expect(response.status).to eq 401
      end
    end
  end
end
