class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, #:validatable
         :jwt_authenticatable, jwt_revocation_strategy: JwtBlacklist
  enum permission: [:admin, :standard]
  before_save :default_permission
  validates :password, :password_confirmation, presence: true
  validates :email, uniqueness: { case_sensitive: false }, presence: true

  private
    def default_permission
      self.permission ||= 'standard'
    end
end
