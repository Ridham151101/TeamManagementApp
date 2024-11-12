class Team < ApplicationRecord
  belongs_to :user, class_name: 'User' # Owner
  has_many :members, dependent: :destroy
  has_many :users, through: :members

  validates :name, :description, presence: true
end
