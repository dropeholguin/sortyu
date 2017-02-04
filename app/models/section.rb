class Section < ApplicationRecord
	belongs_to :photo
	has_many :sortings
end
