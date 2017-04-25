require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe 'index' do
    it 'returns a 200 status' do
      get :index
      expect(response.status).to eq 200
    end
  end
end
