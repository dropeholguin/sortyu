class ProfileController < ApplicationController

	def show
		@photos = Photo.photos(current_user)
	end
	
end
