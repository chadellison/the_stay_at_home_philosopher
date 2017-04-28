# post model
class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  validates_presence_of :user_id, :title, :body

  before_save :downcase_values

  scope :order_and_limit, (-> { order(created_at: :desc, updated_at: :desc).limit(10) })
  scope :paginate, (->(page) { offset((page.to_i - 1) * 10) if page.present? })

  scope :search, (lambda do |text|
    where('title LIKE ? OR body LIKE ?', "%#{text.downcase}%", "%#{text.downcase}%") if text.present?
  end)

  def self.include_associations
    { data: includes(:user, :comments).map(&:serialize_post) }
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
        author: { data: { name: user.full_name, email: user.email } },
        comments: { data: comments.map(&:serialize_comment) }
      }
    }
  end

  def downcase_values
    title.downcase!
    body.downcase!
  end
end
