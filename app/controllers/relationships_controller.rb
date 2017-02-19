class RelationshipsController < ApplicationController
	before_action :find_user
	before_filter :authenticate_user!

	def create
		current_user.follow(@user)
		respond_to do |format|
	    format.html { redirect_to(:back) }
	    format.js {render action: "follow_button" }
  	end
	end

	def destroy
		current_user.unfollow(@user)
		respond_to do |format|
	    format.html { redirect_to(:back) }
	    format.js {render action: "follow_button" }
  	end
	end

	private

	def find_user
		@user = User.find(params[:user_id])
	end

end
