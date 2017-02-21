class RelationshipsController < ApplicationController
	before_action :find_user
	before_filter :authenticate_user!

	def create
		current_user.follow(@user)
		respond_to do |format|
	    format.html { redirect_back(fallback_location: photos_path) }
	    format.js  { render action: "follow_button", locals: { user: @user } }
  	end
	end

	def destroy
		current_user.unfollow(@user)
		respond_to do |format|
			format.html { redirect_back(fallback_location: photos_path) }
	    format.js { render action: "unfollow_button", locals: { user: @user } }
  	end
	end

	private

	def find_user
		@user = User.find(params[:id])
	end

end
