class AfterSignupController < ApplicationController
	include Wicked::Wizard
  before_action :authenticate_user!

  steps :instagram_email, :affiliate

  def show
    @user = current_user
    case step
    when :affiliate
      @url = request.protocol + request.host + "?ref=#{6.times.map { [*'0'..'9', *'A'..'Z'].sample }.join}"
    end
    render_wizard
  end
  
  def update
    @user = current_user
    case step
    when :affiliate
      if params[:affiliate].to_i == 1 
        @user.add_role :affiliate
        @user.update_attributes(user_params)
      end
    when :instagram_email
      @user.skip_confirmation!
      @user.update_attributes(user_params)
    end

    render_wizard @user
  end
  
	private

		def user_params
	    params.require(:user).permit(:email, :url)
  	end
end
