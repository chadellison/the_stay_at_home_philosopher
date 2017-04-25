require 'rails_helper'

describe Api::V1::PostsController do
  describe 'index' do
    it 'returns a 200 status' do
      get :index, format: :json
      expect(response.status).to eq 200
    end
  end
end
