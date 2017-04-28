require 'rails_helper'

RSpec.describe Api::V1::AuthenticationController, type: :controller do
  describe 'create' do
    context 'with the proper email and password' do
      let(:first_name) { Faker::Name.first_name }
      let(:last_name) { Faker::Name.last_name }
      let(:email) { Faker::Internet.email }
      let!(:user) do
        User.create(email: email,
                    password: 'password',
                    first_name: first_name,
                    last_name: last_name)
      end

      it "returns the user's token" do
        post :create, credentials: { email: email, password: 'password' },
                      format: :json

        parsed_response = JSON.parse(response.body)

        expect(response.status).to eq 200
        expect(parsed_response['attributes']['email']).to eq email
        expect(parsed_response['attributes']['encrypted_password']).to be_present
      end
    end

    context 'with improper credentials' do
      let(:email) { Faker::Internet.email }
      let!(:user) { User.create(email: email, password: 'password') }
      let(:bad_password) { Faker::Internet.password }

      it 'returns a 404 status and an error' do
        post :create, credentials: { email: email, password: bad_password },
                      format: :json

        expect(response.status).to eq 404
        expect(JSON.parse(response.body)['encrypted_password']).to be_nil
        expect(JSON.parse(response.body)['errors']).to eq 'Invalid Credentials'
      end
    end

    context 'with an uppercase email' do
      let(:first_name) { Faker::Name.first_name }
      let(:last_name) { Faker::Name.last_name }
      let(:email) { Faker::Internet.email }
      let!(:user) do
        User.create(email: email,
                    password: 'password',
                    first_name: first_name,
                    last_name: last_name)
      end

      it 'finds the email regardless of case' do
        post :create, credentials: { email: email.upcase, password: 'password' },
                      format: :json

        expect(response.status).to eq 200
        expect(JSON.parse(response.body)['attributes']['email']).to eq email
        expect(JSON.parse(response.body)['attributes']['encrypted_password']).to be_present
      end
    end
  end
end
