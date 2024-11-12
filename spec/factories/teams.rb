FactoryBot.define do
  factory :team do
    name { "Team #{Faker::Team.name}" }
    description { "Description of Team A" }
    association :user, factory: :user

    trait :owned_team do
      user { create(:user) } # This ensures a new user is created specifically for this team if needed
    end
  end
end
