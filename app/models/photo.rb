class Photo < ApplicationRecord
    include AASM
    acts_as_votable

    belongs_to :user
    has_many :sections, dependent: :destroy
    has_many :flags, dependent: :destroy
    has_many :seens, dependent: :destroy
    has_one :justification

    has_attached_file :file, styles: {large: "500x500>", medium: "300x300", thumb: "100x100>" }
    validates_attachment_content_type :file, content_type: /\Aimage\/.*\z/
    serialize :dimensions
    before_save :extract_dimensions

    MAXIMUM_PHOTOS = 10
    MAXIMUM_FLAGS = 2

    validate on: :create do
        if user.photos.size >= MAXIMUM_PHOTOS
            errors.add :photo, "You have reached the amount of free images"
        end
    end

    scope :photos, -> (user_id) { where(user_id: user_id) }
    scope :pay_photos, -> (user_id) { where("user_id = ? AND state != ? ", user_id, "paid") }
    scope :photos_sorting, -> (user_id) { where("user_id != ? AND count_flags < ? ", user_id, MAXIMUM_FLAGS) }
    scope :get_photos_paid, -> { where("state = ? AND count_of_sorts < ? ", "paid", 200) }

    aasm column: "state" do
        state :free, initial: true
        state :paid

        event :pay do
            transitions from: :free, to: :paid
        end
    end

    # Retrieves dimensions for image assets
    # @note Do this after resize operations to account for auto-orientation.
    def extract_dimensions
        tempfile = file.queued_for_write[:original]
        unless tempfile.nil?
            geometry = Paperclip::Geometry.from_file(tempfile)
            self.dimensions = [geometry.width.to_i, geometry.height.to_i]
        end
    end
end
