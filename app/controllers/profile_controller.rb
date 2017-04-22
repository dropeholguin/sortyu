class ProfileController < ApplicationController
	
	def show
		@photos = []
		case params[:sort_by].to_i
        when 1
            @photos = Photo.photos(current_user).order( 'count_of_sorts DESC' )
        when 2
            @photos = Photo.photos(current_user).order(cached_votes_up: :desc)
        when 3
            @photos = Photo.photos(current_user).order( 'state DESC' )
        else
			@photos = Photo.photos(current_user).order('created_at desc')        
		end
	end

	def other_user_show
		@user = User.find(params[:id])
		@photos = Photo.photos(@user.id).order('created_at desc')
	end

	def affiliate
		@user = Affiliate.find(params[:id])
	end
	
end
