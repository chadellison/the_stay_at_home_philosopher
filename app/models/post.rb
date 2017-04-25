# post model
class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  validates_presence_of :user_id, :title, :body

  scope :post_order, (-> { order(created_at: :desc, updated_at: :desc).limit(10) })
  scope :paginate, (->(page) { offset((page.to_i - 1) * 10) if page.present? })

  def self.include_users(posts)
    post_data = posts.includes(:user).map do |post|
      {
        type: 'post',
        id: post.id,
        attributes: { title: post.title, body: post.body },
        relationships: { author: post.user.full_name }
      }
    end

    { data: post_data }
  end
end
