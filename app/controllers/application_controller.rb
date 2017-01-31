class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_photos_array

	def set_photos_array
		if user_signed_in?
			if cookies[:photos_queue].empty?
				cookies[:photos_queue] = { value: Photo.photos_sorting(current_user.id).limit(5).pluck(:id), expires: 1.day }
			end
		end
	end

end
