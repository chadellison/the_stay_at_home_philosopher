require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has many posts' do
    expect(User.new).to respond_to(:posts)
  end
end
