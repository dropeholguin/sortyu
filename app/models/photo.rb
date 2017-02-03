class Photo < ApplicationRecord
	include AASM
  acts_as_votable
  
  belongs_to :user
  has_many :sections

  has_attached_file :file, styles: { medium: "300x300#", thumb: "100x100>" }
  validates_attachment_content_type :file, content_type: /\Aimage\/.*\z/

  scope :photos, -> (user_id) { where(user_id: user_id) }
  scope :photos_sorting, -> (user_id) { where("user_id != ? AND seen = ?", user_id, false) }

  aasm column: "state" do
		state :free, initial: true
    state :paid

    event :pay do
    	transitions from: :free, to: :paid
    end
	end
end
