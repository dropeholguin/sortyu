
Paperclip.interpolates(:s3_bucket) do |attachement, style|
	Rails.application.config.paperclip_defaults[:s3_credentials][:bucket]
end
Paperclip::Attachment.default_options[:s3_protocol] = "https"