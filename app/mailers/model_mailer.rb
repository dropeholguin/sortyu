class ModelMailer < ApplicationMailer
	default from: 'plentious@gmail.com'

	def remove_photo(photo)
		@photo = photo
		mail(to: @photo.user.email, subject: "Your photo was deleted")
	end

	def suspend_photo(photo)
		@photo = photo
		mail(to: @photo.user.email, subject: "Your photo was suspended")
	end

	def approve_photo(photo)
		@photo = photo
		mail(to: @photo.user.email, subject: "Your photo was approved")
	end
	
end
