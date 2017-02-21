class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def facebook
    auth = env["omniauth.auth"]

    if user_signed_in?
      User.connect_to_facebook(current_user, auth)
      flash[:notice] = "Facebook Integrate successfully"
      redirect_to profile_show_url
    else
    # You need to implement the method below in your model (e.g. app/models/user.rb)
      @user = User.find_for_facebook_oauth(request.env["omniauth.auth"])

      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
        set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
      else
        session["devise.facebook_data"] = request.env["omniauth.auth"]
        redirect_to root_path
      end
    end
  end

  def instagram
    auth = env["omniauth.auth"]

    if user_signed_in?
      User.connect_to_instagram(current_user, auth)
      flash[:notice] = "Instagram Integrate successfully"
      redirect_to profile_show_url
    else
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      @user = User.find_for_instagram_oauth(request.env["omniauth.auth"])

      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
        set_flash_message(:notice, :success, kind: "Instagram") if is_navigational_format?
      else
        session["devise.instagram_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
    end
  end

  def google_oauth2
    auth = env["omniauth.auth"]

    if user_signed_in?
      User.connect_to_google(current_user, auth)
      flash[:notice] = "Google Integrate successfully"
      redirect_to profile_show_url
    else
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      @user = User.find_for_google_oauth(request.env["omniauth.auth"])

      if @user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: "Google"
        sign_in_and_redirect @user, event: :authentication
      else
        session["devise.google_data"] = request.env["omniauth.auth"].except(:extra) #Removing extra as it can overflow some session stores
        redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
      end
    end
  end
end
