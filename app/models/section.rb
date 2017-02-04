class Section < ApplicationRecord
	belongs_to :photo
	has_many :sortings
	has_one :sorting_information
end
