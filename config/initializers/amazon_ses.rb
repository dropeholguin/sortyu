ActionMailer::Base.add_delivery_method :ses, AWS::SES::Base,
	server: "ses-smtp-user.20170125-170541",
	access_key_id: ENV['AMAZON_ACCESS_KEY'],
	secret_access_key: ENV['AMAZON_SECRET_KEY']