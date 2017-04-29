class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  validates_presence_of :body, :user_id, :post_id

  scope :order_and_limit, (-> { order(:created_at, :updated_at).limit(10) })
  scope :paginate, (->(page) { offset((page.to_i - 1) * 10) if page.present? })

  def serialize_comment
    {
      type: 'comment',
      id: id,
      attributes: {
        body: body,
        created_at: created_at.to_date,
        updated_at: updated_at.to_date
      },
      relationships: { author: { data: { name: user.full_name,
                                         hashed_email: user.hashed_email } } }
    }
  end
end
