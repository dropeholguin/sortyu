class UsersController < ApplicationController
	
	def create_reviewer_role
    user = User.find(params[:id])
    user.add_role :reviewer
    redirect_to admin_users_url, notice: "User was successfully updated."
  end

  def remove_reviewer_role
    user = User.find(params[:id])
    user.remove_role :reviewer
    redirect_to admin_users_url, notice: "User was successfully updated."
  end
end
