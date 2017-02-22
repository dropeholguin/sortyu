class Sorting < ApplicationRecord
	scope :user_sorting, ->(user_id, photo_id) { where(user_id: user_id).joins(:section).where("sections.photo_id = ?", photo_id) }
	belongs_to :user
	belongs_to :section
end
