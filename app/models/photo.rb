class Photo < ApplicationRecord
  belongs_to :user
  has_many :sections

  validates :description, presence: true
  has_attached_file :file, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :file, content_type: /\Aimage\/.*\z/
end
