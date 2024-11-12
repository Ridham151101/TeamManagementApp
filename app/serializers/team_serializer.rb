class TeamSerializer < ActiveModel::Serializer
  attributes :id, :name, :description
  has_many :members

  class MemberSerializer < ActiveModel::Serializer
    attributes :id, :user_id, :team_id
  end
end