# post model
class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  validates_presence_of :user_id, :title, :body

  scope :order_and_limit, (-> { order(created_at: :desc, updated_at: :desc).limit(10) })
  scope :paginate, (->(page) { offset((page.to_i - 1) * 10) if page.present? })

  def self.include_associations(posts)
    post_data = posts.includes(:user, :comments).map(&:serialize_post)
    { data: post_data }
  end

  def serialize_post
    {
      type: 'post',
      id: id,
      attributes: {
        title: title,
        body: body,
        created_at: created_at.to_date,
        updated_at: updated_at.to_date
      },
      relationships: {
        author: user.full_name,
        comments: comments.map(&:serialize_comment)
      }
    }
  end
end
