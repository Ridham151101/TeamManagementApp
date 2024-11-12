module ApplicationHelper
  def team_owner?
    current_user.roles.exists?(name: 'team_owner')
  end
end
