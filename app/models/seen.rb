class Seen < ApplicationRecord
	belongs_to :user
	belongs_to :photo
	scope :get_sort_last_twenty_four_hours, ->(user_id) { where( "user_id = ? AND created_at > ?", user_id, 24.hours.ago )}
	scope :get_sort_today, ->(user_id) { where("user_id = ? AND created_at >= ?", user_id, Time.zone.now.beginning_of_day) }
	scope :get_sort_this_week, ->(user_id){where("user_id = ? AND created_at >= ?", user_id, 1.week.ago.utc) }
	scope :get_sort_this_month, ->(user_id){where("user_id = ? AND created_at >= ?", user_id, Time.now.beginning_of_month)}
	scope :get_sort_last_ninety_days, ->(user_id){where("user_id = ? AND created_at >= ?", user_id, 90.days.ago)}
end
