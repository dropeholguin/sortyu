class ProfileController < ApplicationController

	def show
		@photos = Photo.photos(current_user)
	end

	def other_user_show
		@user = User.find(params[:id])
		@photos = Photo.photos(@user.id)
	end
	
end
