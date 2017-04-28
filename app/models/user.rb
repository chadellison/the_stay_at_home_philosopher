class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :posts
  has_many :comments
  validates_presence_of :first_name, :last_name

  def full_name
    first_name.capitalize + ' ' + last_name.capitalize
  end

  def serialize_user
    {
      type: 'user',
      id: id,
      attributes: {
        first_name:         first_name,
        last_name:          last_name,
        email:              email,
        encrypted_password: encrypted_password,
        about_me:           about_me
      },
      relationships: {
        comments: { data: comments.map(&:serialize_comment) },
        posts: { data: posts.map(&:serialize_post) }
      }
    }
  end
end
