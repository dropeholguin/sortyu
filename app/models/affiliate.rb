class Affiliate < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :users
  
  def active_for_authentication?
    super and self.is_active?
  end

  def full_name
    [first_name, last_name].join(' ')
  end
end
