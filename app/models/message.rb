class Message

  include ActiveModel::Model
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :subject, :email, :message

  validates :subject,
    presence: true

  validates :email,
    presence: true

  validates :message,
    presence: true

end
