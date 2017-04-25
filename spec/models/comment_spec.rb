require 'rails_helper'

RSpec.describe Comment, type: :model do
  it 'belongs to a post' do
    expect(Comment.new).to respond_to(:post)
  end

  it 'belongs to a user' do
    expect(Comment.new).to respond_to(:user)
  end

  it 'validates the presence of a body' do
    comment = Comment.new(user_id: Faker::Number.number(4),
                          post_id: Faker::Number.number(4))
    expect(comment.valid?).to be false
    expect(comment.errors['body']).to eq ["can't be blank"]
  end

  it 'validates the presence of a user' do
    comment = Comment.new(body: Faker::Lorem.paragraph,
                          post_id: Faker::Number.number(4))

    expect(comment.valid?).to be false
    expect(comment.errors['user_id']).to eq ["can't be blank"]
  end

  it 'validates the presence of a post' do
    comment = Comment.new(body: Faker::Lorem.paragraph,
                          user_id: Faker::Number.number(4))

    expect(comment.valid?).to be false
    expect(comment.errors['post_id']).to eq ["can't be blank"]
  end
end
