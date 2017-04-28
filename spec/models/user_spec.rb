require 'rails_helper'

RSpec.describe User, type: :model do
  let(:first_name) { Faker::Name.first_name }
  let(:last_name) { Faker::Name.last_name }
  let(:email) { Faker::Internet.email }
  let(:password) { Faker::Internet.password }

  it 'has many posts' do
    expect(User.new).to respond_to(:posts)
  end

  it 'has many comments' do
    expect(User.new).to respond_to(:comments)
  end

  it 'validates the presence of first_name' do
    user = User.new(last_name: last_name, email: email, password: password)
    expect(user.valid?).to be false
    expect(user.errors[:first_name]).to eq ["can't be blank"]
  end

  it 'validates the presence of last_name' do
    user = User.new(first_name: first_name, email: email, password: password)
    expect(user.valid?).to be false
    expect(user.errors[:last_name]).to eq ["can't be blank"]
  end

  it 'validates the presence of email' do
    user = User.new(first_name: first_name,
                    last_name: last_name,
                    password: password)
    expect(user.valid?).to be false
    expect(user.errors[:email]).to eq ["can't be blank"]
  end

  it 'validates the uniqueness of email' do
    User.create(first_name: first_name,
                last_name: last_name,
                email:      email,
                password: password)

    user = User.new(first_name: first_name,
                    last_name: last_name,
                    email:      email,
                    password: password)
    expect(user.valid?).to be false
    expect(user.errors[:email]).to eq ['has already been taken']
  end

  it 'validates the presence of password' do
    user = User.new(first_name: first_name,
                    last_name: last_name,
                    email: email)
    expect(user.valid?).to be false
    expect(user.errors[:password]).to eq ["can't be blank"]
  end

  describe 'full_name' do
    it 'returns the capitalized first and last name of a user' do
      password = Faker::Internet.password
      user = User.new(email: Faker::Internet.email,
                      password: password,
                      first_name: 'bob',
                      last_name: 'jones')

      expect(user.full_name).to eq 'Bob Jones'
    end
  end

  describe 'serialize_user' do
    it 'returns a json api serialzed user' do
      user = User.new(email: Faker::Internet.email,
                      password: password,
                      first_name: 'bob',
                      last_name: 'jones',
                      about_me: 'about bob jones')

      expect(user.serialize_user[:attributes][:first_name]).to eq 'bob'
      expect(user.serialize_user[:attributes][:last_name]).to eq 'jones'
      expect(user.serialize_user[:attributes][:about_me]).to eq 'about bob jones'
      expect(user.serialize_user[:relationships][:posts][:data]).to eq []
      expect(user.serialize_user[:relationships][:comments][:data]).to eq []
    end
  end
end
