class UserLocksController < ApplicationController

	def lock_access
		user = User.find(params[:id])
		user.lock_access!
		redirect_to root_path
	end

end
