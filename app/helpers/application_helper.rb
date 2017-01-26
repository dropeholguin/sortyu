module ApplicationHelper

	def avatar_profile_link(user, style="", image_options={})
	    if style.empty?
	      avatar_url = user.avatar? ? user.avatar.url : user.gravatar_url
	    else
	      avatar_url = user.avatar? ? user.avatar.url(style.to_sym) : user.gravatar_url(style)
	    end
	    image_tag(avatar_url, image_options)
	end
	
end
