class User < ApplicationRecord
  has_secure_password

  has_many :articles

  scope :admin, -> { where(role: 'admin') }
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?
#  atleast one capital case atleast one special character atleast one number.
#  minimum length 8
  ROLES = %i(admin editor writer)

  ROLES.each do |role_name|
    define_method "is_#{role_name}?" do
      self.role == role_name.to_s 
    end
  end



  private

  def password_required?
    new_record? || !password.nil?
  end


end
