class Seen < ApplicationRecord
	belongs_to :user
	belongs_to :photo
	scope :get_photos_last_twenty_four_hours, ->(user_id) { where( "user_id = ? AND created_at > ?", user_id, 24.hours.ago )}
end
