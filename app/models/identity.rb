class Identity < ApplicationRecord
  belongs_to :user
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, scope: :provider

  scope :identity_facebook, -> (user_id, provider) { where(user_id: user_id).where(provider: provider) }
  scope :identity_instagram, -> (user_id, provider) { where(user_id: user_id).where(provider: provider) }
  scope :identity_google, -> (user_id, provider) { where(user_id: user_id).where(provider: provider) }

  
  def self.find_for_oauth(auth)
    find_by(uid: auth.uid, provider: auth.provider)
  end

  def self.create_with_omniauth_facebook(auth, user_id)
    create(user_id: user_id, uid: auth.uid, provider: auth.provider, oauth_token: auth.credentials.token)
  end

  def self.create_with_omniauth_instagram(auth, user_id)
    create(user_id: user_id, uid: auth.uid, provider: auth.provider, oauth_token: auth.credentials.token)
  end

  def self.create_with_omniauth_google(auth, user_id)
    create(user_id: user_id, uid: auth.uid, provider: auth.provider, oauth_token: auth.credentials.token)
  end
end
