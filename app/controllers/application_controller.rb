class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception
	before_action :set_site_cookies
	rescue_from CanCan::AccessDenied do |exception|
		redirect_to root_url, alert: exception.message
	end

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

	def after_sign_in_path_for(resource)
		if request.env['affiliate.tag'] && affiliate = Affiliate.find(request.env['affiliate.tag'])
			if !affiliate_signed_in?
				resource.update_attributes(affiliate_id: affiliate.id)
	      		puts "Halo, referral! You've been referred here by #{affiliate.full_name}"
			end
	    else
	    	puts "We're glad you found us on your own!"
	    end
    	request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  	end

end
