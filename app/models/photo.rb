class Photo < ApplicationRecord
    include AASM
    acts_as_votable
    acts_as_taggable
    acts_as_taggable_on :tags
    
    belongs_to :user
    has_many :sections, dependent: :destroy
    has_many :flags, dependent: :destroy
    has_many :seens, dependent: :destroy
    has_one :justification

    has_attached_file :file, styles: {large: "500x500>", medium: "300x300", thumb: "100x100>" }
    validates_attachment_content_type :file, content_type: /\Aimage\/.*\z/
    serialize :dimensions
    before_save :extract_dimensions

    MAXIMUM_FLAGS = 2

    scope :photos, -> (user_id) { where("user_id = ? AND tmp = ?", user_id, false ) }
    scope :destroy_photos_tmp, -> { where("tmp = ?", true) }
    scope :tmp_photos, -> (user_id) { where("user_id = ? AND state = ? AND tmp = ?", user_id, "free", false) }
    scope :free_photos, -> (user_id) { where("user_id = ? AND state = ?", user_id, "free") }
    scope :photos_sorting, -> (user_id) { where("user_id != ? AND count_flags < ? AND tmp = ? AND state != ?", user_id, MAXIMUM_FLAGS, false, "draft") }
    scope :get_photos_paid, -> { where("state = ? AND count_of_sorts < ?", "paid", 200,) }
    scope :photos_draft, -> (user_id) {where("user_id = ? AND tmp = ? AND state = ?", user_id, false, "draft")}
    
    aasm column: "state" do
        state :draft, initial: true
        state :free
        state :paid
        event :pay do
            transitions from: :free, to: :paid
        end
        
        event :spend_free do
            transitions from: :draft, to: :free
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
