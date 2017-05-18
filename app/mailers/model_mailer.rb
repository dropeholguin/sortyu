class ModelMailer < ApplicationMailer
	default from: 'admin@sortyu.com'

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

	def suspend_account(user)
		@user = user
		mail(to: @user.email, subject: "Your account was suspended")
	end

	def active_account_affiliate(affiliate)
		@affiliate = affiliate
		mail(to: @affiliate.email, subject: "Your account was approved")
	end

	def suspend_account_affiliate(affiliate)
		@affiliate = affiliate
		mail(to: @affiliate.email, subject: "Your account was suspended")
	end

	def send_message(email, subject, message )
		@email = email
		@subject = subject
		@message = message
		mail(to: 'admin@sortyu.com', subject: subject)
	end
end
