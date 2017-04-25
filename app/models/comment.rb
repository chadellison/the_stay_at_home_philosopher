class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  validates_presence_of :body, :user_id, :post_id

  scope :comment_order, (-> { order(:created_at, :updated_at).limit(10) })
  scope :paginate, (->(page) { offset((page.to_i - 1) * 10) if page.present? })

  def self.include_users(comments)
    comment_data = comments.includes(:user).map do |comment|
      {
        type: 'comment',
        id: comment.id,
        attributes: { body: comment.body },
        relationships: { author: comment.user.full_name }
      }
    end

    { data: comment_data }
  end
end
