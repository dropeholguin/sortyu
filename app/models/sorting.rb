class Sorting < ApplicationRecord
  belongs_to :user
  belongs_to :section

  scope :user_sortings, ->(user_id, photo_id) { where(user_id: user_id).joins(:section).where("sections.photo_id = ?", photo_id) }
end
