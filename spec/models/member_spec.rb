require 'rails_helper'

RSpec.describe Member, type: :model do
  let(:user) { create(:user) } # Assuming you have a factory for User
  let(:team) { create(:team) } # Assuming you have a factory for Team
  let(:member) { create(:member, user: user, team: team) } # Create a member with associations

  # Association tests
  describe "associations" do
    it "belongs to a user" do
      expect(member.user).to eq(user)
    end

    it "belongs to a team" do
      expect(member.team).to eq(team)
    end
  end
end
