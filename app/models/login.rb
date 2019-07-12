class Login < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         # :recoverable, :rememberable, :validatable
         :jwt_authenticatable, jwt_revocation_strategy: JwtBlacklist
  belongs_to :user, polymorphic: true
  accepts_nested_attributes_for :user


  def build_user(params)
    self.user = user_type.constantize.new(params)
  end
end
