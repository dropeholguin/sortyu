class Photo < ApplicationRecord
	include AASM
  acts_as_votable
  
  belongs_to :user
  has_many :sections, dependent: :destroy
  has_many :flags, dependent: :destroy
  has_many :seens, dependent: :destroy

  has_attached_file :file, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :file, content_type: /\Aimage\/.*\z/

  MAXIMUM_PHOTOS = 10

  validate on: :create do
    if user.photos.size >= MAXIMUM_PHOTOS
      errors.add :photo, "You have reached the amount of free images"
    end
  end

  scope :photos, -> (user_id) { where(user_id: user_id) }
  scope :photos_sorting, -> (user_id) { where("user_id != ? ", user_id) }

  aasm column: "state" do
		state :free, initial: true
    state :paid

    event :pay do
    	transitions from: :free, to: :paid
    end
	end
end
