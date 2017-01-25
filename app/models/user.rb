class User < ApplicationRecord
  # Include default devise modules. Others available are:
  #:lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :confirmable
         
  has_many :photos
  has_many :likes

  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(email: email).first if email

      # Create the user if it's a new registration
      if user.nil?
      	if identity.provider == "instagram"
      		user = User.new(
	        	first_name: auth.extra.raw_info.full_name.split(" ")[0], 
	          last_name: auth.extra.raw_info.full_name.split(" ")[1],
	          email: auth.extra.raw_info.username + "@instagram.com",
	          password: Devise.friendly_token[0,20]
	        )
	        user.save!
      	else
	        user = User.new(
	        	first_name: auth.extra.raw_info.name.split(" ")[0], 
	          last_name: auth.extra.raw_info.name.split(" ")[1],
	          email: auth.info.email,
	          password: Devise.friendly_token[0,20]
	        )
	        user.save!
	      end
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    
    #Set oauth_token to identity
    if identity.oauth_token.nil?
      identity.oauth_token = auth.credentials.token
      identity.save!
    end

    user
  end

  def facebook(user)
    identity = Identity.identity_facebook(user.id, "facebook").first
    @facebook ||= Koala::Facebook::API.new(identity.oauth_token)
  end

end
