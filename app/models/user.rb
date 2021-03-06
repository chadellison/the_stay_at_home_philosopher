class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :posts
  has_many :comments
  validates_presence_of :first_name, :last_name

  before_save :hash_email

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
        hashed_email:       hashed_email,
        encrypted_password: encrypted_password,
        about_me:           about_me
      },
      relationships: {
        comments: { data: comments.map(&:serialize_comment) },
        posts: { data: posts.map(&:serialize_post) }
      }
    }
  end

  def hash_email
    self.hashed_email = Digest::MD5.hexdigest(email.downcase.strip)
  end
end
