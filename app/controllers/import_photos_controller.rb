class ImportPhotosController < ApplicationController
	before_filter :authenticate_user!

	def import_facebook
		@user = current_user
		@photos = @user.facebook(@user).get_connections("me","photos?fields=picture,name")
	end

	def import_instagram
		@user = current_user
    client = Instagram.client(access_token: @user.instagram(@user).oauth_token)
    @results = client.recent
	end
end