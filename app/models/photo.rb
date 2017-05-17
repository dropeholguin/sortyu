class Photo < ApplicationRecord
    include Tire::Model::Search
    include Tire::Model::Callbacks
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
    scope :following_photos, -> (user_id) { where("user_id = ? AND count_flags < ? AND tmp = ? AND draft = ?", user_id, MAXIMUM_FLAGS, false, false) }
    scope :photos_sorting, -> (user_id) { where("user_id != ? AND count_flags < ? AND tmp = ? AND draft = ?", user_id, MAXIMUM_FLAGS, false, false) }
    scope :get_photos_paid, -> { where("state = ? AND count_of_sorts < ?", "paid", 200,) }
    scope :photos_draft, -> (user_id) {where("user_id = ? AND tmp = ? AND draft = ?", user_id, false, true)}
    
    aasm column: "state" do
        state :free, initial: true
        state :paid
        event :pay do
            transitions from: :free, to: :paid
        end
    end

    index_name("photos")
    mapping do
        indexes :id, index: :not_analyzed
        indexes :tag_list, type: 'string', analyzer: 'keyword'
    end

    def self.search(params)
        tire.search(load: true) do
            query { string params[:query] } if params[:query].present?
            filter :terms, tag_list: [params[:the_tag]] if params[:the_tag].present?
        end
    end

    def to_indexed_json
        to_json(methods: [:tag_list])
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
