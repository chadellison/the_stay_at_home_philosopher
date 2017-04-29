require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'create' do
    context 'with incomplete information' do
      it 'returns an error' do
        email = Faker::Internet.email

        expect do
          post :create, user: { email: email, password: ''}, format: :json
        end.not_to change { User.count }

        expect(response.status).to eq 404
        error_message = "password can't be blank\nfirst_name can't be blank\nlast_name can't be blank"
        expect(JSON.parse(response.body)['errors']).to eq error_message
      end
    end

    context 'with complete information' do
      let(:email) { Faker::Internet.email }
      let(:first_name) { Faker::Name.first_name }
      let(:last_name) { Faker::Name.last_name }

      it 'creates a user' do
        params = {
          user: {
            email: email,
            password: Faker::Number.number(8),
            first_name: first_name,
            last_name: last_name
          }
        }

        expect do
          post :create, user: { email: email,
                                password: Faker::Number.number(8),
                                first_name: first_name,
                                last_name: last_name }, format: :json
        end.to change { User.count }.by(1)

        expect(response.status).to eq 201
        expect(JSON.parse(response.body)['attributes']['first_name']).to eq first_name
        expect(JSON.parse(response.body)['attributes']['last_name']).to eq last_name
      end
    end
  end
end
