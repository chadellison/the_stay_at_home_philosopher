# post model
class Post < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id, :title, :body

  scope :post_order, (-> { order(updated_at: :desc).limit(10) })
  scope :paginate, (->(page) { offset((page.to_i - 1) * 10) if page.present? })
end
