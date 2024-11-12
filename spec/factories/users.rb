FactoryBot.define do
  factory :user do
    first_name { "John" }
    last_name { "Doe" }
    email { Faker::Internet.unique.email }  # This ensures a unique email
    password { 'password123' }
    password_confirmation { "password123" }
    # other attributes
  end
end
