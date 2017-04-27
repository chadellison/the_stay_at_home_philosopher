class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  validates_presence_of :body, :user_id, :post_id

  scope :comment_order, (-> { order(:created_at, :updated_at).limit(10) })
  scope :paginate, (->(page) { offset((page.to_i - 1) * 10) if page.present? })

  def include_user
    {
      type: 'comment',
      id: id,
      attributes: {
        body: body,
        created_at: created_at.to_date,
        updated_at: updated_at.to_date
      },
      relationships: { author: user.full_name }
    }
  end
end
