class Sorting < ApplicationRecord
  belongs_to :user
  belongs_to :section

  scope :user_sortings, ->(user_id, photo_id) { where(user_id: user_id).joins(:section).where("sections.photo_id = ?", photo_id) }
  scope :get_last_eighteen_hours, -> { where( "created_at >= ?", 18.hours.ago )}
  scope :get_last_thirty_days, -> { where( "created_at >= ?", 30.days.ago)}
end
