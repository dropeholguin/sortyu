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
    @max_num = @results["data"].count - 1
	end

	def import_google
		@user = current_user
		person = GooglePlus::Person.get(@user.google(@user).uid, access_token: @user.google(@user).oauth_token)
	end
end
