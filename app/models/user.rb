class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtBlacklist

  has_many :owned_teams, class_name: 'Team', foreign_key: 'user_id', dependent: :destroy
  has_many :memberships, class_name: 'Member', foreign_key: 'user_id', dependent: :destroy
  has_many :teams, through: :memberships

  validates :first_name, :last_name, presence: true
end
