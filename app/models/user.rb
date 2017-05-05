class User < ApplicationRecord
  rolify
  acts_as_voter
  # Include default devise modules. Others available are:
  #:timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :confirmable, :lockable
  validates :first_name, :last_name, presence: true
  validates :username, presence: true, uniqueness: true,
                    format: {
                             #fix bug whit a username
                             with: /[a-zA-Z0-9_-]/,
                             message: 'Must be formatted correctly.'
                           }
  has_many :photos
  has_many :sortings
  has_many :identities

  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  belongs_to :affiliate
  has_attached_file :avatar , styles: { medium: "700x700#", thumb: "100x100#" }
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  scope :referred_users, -> (affiliate_id) { where("affiliate_id = ?", affiliate_id) }

  def active_for_authentication?
    super and self.is_active?
  end

  def self.find_for_facebook_oauth(auth)

    user = User.joins(:identities).where("identities.provider = ? AND identities.uid = ?", auth.provider, auth.uid).first    
    
    # The User was found in our database    
    return user if user    
    # Check if the User is already registered without Facebook      
    user = User.where(email: auth.info.email).first 

    return user if user
    image = process_url(auth.info.image + '?type=large')
    user = User.new(
      first_name: auth.extra.raw_info.name.split(" ")[0], 
      last_name: auth.extra.raw_info.name.split(" ")[1],
      username:  auth.extra.raw_info.name,
      email: auth.info.email,
      avatar: image,
      password: Devise.friendly_token[0,20])

    user.skip_confirmation!
    user.save!
    Identity.create_with_omniauth_facebook(auth, user.id)
    user
  end

  def self.find_for_instagram_oauth(auth)

    user = User.joins(:identities).where("identities.provider = ? AND identities.uid = ?", auth.provider, auth.uid).first    
    
    # The User was found in our database    
    return user if user    
    # Check if the User is already registered without Facebook      
    user = User.where(username: auth.extra.raw_info.username).first 

    return user if user
    user = User.new(
      first_name: auth.extra.raw_info.full_name.split(" ")[0], 
      last_name: auth.extra.raw_info.full_name.split(" ")[1],
      username:  auth.extra.raw_info.username,
      email: auth.extra.raw_info.username + "@instagram.com",
      avatar: auth.extra.raw_info.profile_picture,
      password: Devise.friendly_token[0,20])

    user.skip_confirmation!
    user.save!
    Identity.create_with_omniauth_instagram(auth, user.id)
    user
  end

  def self.find_for_google_oauth(auth)

    user = User.joins(:identities).where("identities.provider = ? AND identities.uid = ?", auth.provider, auth.uid).first    
    
    # The User was found in our database    
    return user if user    
    # Check if the User is already registered without Facebook      
    user = User.where(email: auth.info.email).first 

    return user if user
    user = User.new(
      first_name: auth.info.first_name, 
      last_name: auth.info.last_name,
      username:  auth.info.first_name.gsub(/\s+/, ""),
      email: auth.info.email,
      password: Devise.friendly_token[0,20])

    user.skip_confirmation!
    user.save!
    Identity.create_with_omniauth_google(auth, user.id)
    user
  end

  def facebook(user)
    identity = Identity.identity_facebook(user.id, "facebook").first
    @facebook ||= Koala::Facebook::API.new(identity.oauth_token)
  end

  def instagram(user)
    identity = Identity.identity_instagram(user.id, "instagram").first
  end

  def google(user)
    identity = Identity.identity_google(user.id, "google_oauth2").first
  end

  def self.connect_to_instagram(user, auth)
    Identity.create_with_omniauth_instagram(auth, user.id)
  end

  def self.connect_to_facebook(user, auth)
    Identity.create_with_omniauth_facebook(auth, user.id)
  end

  def self.connect_to_google(user, auth)
    Identity.create_with_omniauth_google(auth, user.id)
  end

  def full_name
    [first_name, last_name].join(' ')
  end

  def gravatar_url style=""
    "avatar-user-default.png"
  end

  def self.process_url(uri)
    avatar_url = URI.parse(uri)
    avatar_url.scheme = 'https'
    avatar_url.to_s
  end

  def following?(user)
    following.include?(user)
  end

  def follow(user)
    active_relationships.create!(followed_id: user.id)
  end

  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end

end
