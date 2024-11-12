require 'rails_helper'

RSpec.describe Team, type: :model do
  let(:owner) { create(:user) } # Assuming you have a factory for User
  let(:team) { create(:team, user: owner) } # Create a team with the owner
  let(:member) { create(:user) } # Assuming you have a factory for User
  
  # Validation tests
  describe "validations" do
    it "is valid with valid attributes" do
      expect(team).to be_valid
    end

    it "is not valid without a name" do
      team.name = nil
      expect(team).to_not be_valid
    end

    it "is not valid without a description" do
      team.description = nil
      expect(team).to_not be_valid
    end
  end

  # Association tests
  describe "associations" do
    it "belongs to a user (owner)" do
      expect(team.user).to eq(owner)
    end

    it "has many members" do
      member = create(:user)
      team.members.create(user: member)
      expect(team.members.count).to eq(1)
    end

    it "has many users through members" do
      team.members.create(user: member)
      expect(team.users).to include(member)
    end
  end
end
