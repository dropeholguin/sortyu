class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_site_cookies

	def set_site_cookies
		if user_signed_in?
			if cookies[:photos_queue].nil?
				cookies[:photos_queue] = ""
			end
			if cookies[:import_queue].nil?
				cookies[:import_queue] = ""
			end
		end
	end

end
