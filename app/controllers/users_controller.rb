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

  def suspend_account
    user = User.find(params[:id])
    user.update_attributes is_active: false
    redirect_to admin_users_url, notice: "Account suspended."
  end

  def active_account
    user = User.find(params[:id])
    user.update_attributes is_active: true
    redirect_to admin_users_url, notice: "Account Actived."
  end
end
