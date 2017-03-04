class Flag < ApplicationRecord
	belongs_to :user
	belongs_to :photo

	validates :reason, presence: true
end
