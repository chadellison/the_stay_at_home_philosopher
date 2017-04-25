require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe 'show' do
    it 'returns a 200 status' do
      post = Post.create(title:   Faker::Name.name,
                         body:    Faker::Lorem.paragraph,
                         user_id: Faker::Number.number(4))

      get :show, id: post.id
      expect(response.status).to eq 200
    end
  end
end
