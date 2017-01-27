class Identity < ApplicationRecord
  belongs_to :user
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, scope: :provider

  scope :identity_facebook, -> (user_id, provider) { where(user_id: user_id).where(provider: provider) }
  scope :identity_instagram, -> (user_id, provider) { where(user_id: user_id).where(provider: provider) }
  
  def self.find_for_oauth(auth)
    find_or_create_by(uid: auth.uid, provider: auth.provider)
  end
end
