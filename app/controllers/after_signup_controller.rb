class AfterSignupController < ApplicationController
	include Wicked::Wizard

  steps :instagram_email

  def show
    @user = current_user
    render_wizard
  end
  
  def update
    @user = current_user
    @user.update_attributes(user_params)
    @user.skip_confirmation!
    render_wizard @user
  end
  
	private

		def user_params
	    params.require(:user).permit(:email)
  	end
end
