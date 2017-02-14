class Section < ApplicationRecord
	belongs_to :photo
	has_many :sortings
	has_one :sorting_information

	scope :photo_sections, -> (photo_id) { where("photo_id = ?", photo_id) }

	def calculate_mode(orders)
		freq = orders.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
		order = orders.max_by { |v| freq[v] }
		return order
	end

	def calculate_average(orders)
		average = orders.inject{ |sum, el| sum + el }.to_f / orders.size
		return average
	end
end
