class MemberSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :team_id
  belongs_to :user

  class UserSerializer < ActiveModel::Serializer
    attributes :id, :first_name, :last_name, :email
  end
end