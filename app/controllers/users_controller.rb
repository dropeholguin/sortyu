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
    ModelMailer.suspend_account(user).deliver
    redirect_to admin_users_url, notice: "Account suspended."
  end

  def active_account
    user = User.find(params[:id])
    user.update_attributes is_active: true
    redirect_to admin_users_url, notice: "Account Actived."
  end

  def hide_results
    if current_user.hide_results?
      puts 'yiooooooooooooooooooooooooooooooooooooooo'
      current_user.hide_results = false
      current_user.save
    else
      puts 'yaaaaaaaaaaaaaaaaaaaaaaa'
      current_user.hide_results = true
      current_user.save

    end
  end

end
