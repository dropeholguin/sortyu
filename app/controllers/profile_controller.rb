class ProfileController < ApplicationController
	before_filter :authenticate_user!
	
	def show
		@photos = Photo.photos(current_user).order('created_at desc')
	end

	def other_user_show
		@user = User.find(params[:id])
		@photos = Photo.photos(@user.id).order('created_at desc')
	end
	
end
