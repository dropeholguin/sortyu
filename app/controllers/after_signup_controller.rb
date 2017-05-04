class AfterSignupController < ApplicationController
	include Wicked::Wizard
  before_action :authenticate_user!

  steps :instagram_email

  def show
    @user = current_user
    render_wizard
  end
  
  def update
    @user = current_user
    case step
    when :instagram_email
      @user.skip_reconfirmation!
      @user.update_attributes(user_params)
    end
    render_wizard @user
  end

  private
    def user_params
      params.require(:user).permit(:username, :email, :password, :encrypted_password)
    end
end
