# Create Roles
Role.create(name: 'team_owner') unless Role.exists?(name: 'team_owner')
Role.create(name: 'member') unless Role.exists?(name: 'member')

# Creating Users with Roles
user1 = User.create(first_name: 'Ridham', last_name: 'Patel', email: 'ridhamvavaliya1511@gmail.com', password: 'password', password_confirmation: 'password')
user1.add_role('team_owner')

user2 = User.create(first_name: 'Prince', last_name: 'Kathiriya', email: 'pk@gmail.com', password: 'password', password_confirmation: 'password')
user2.add_role('member')

user3 = User.create(first_name: 'Ronak', last_name: 'Bhimani', email: 'ronakbhimani@gmail.com', password: 'password', password_confirmation: 'password')
user3.add_role('member')

user4 = User.create(first_name: 'Parth', last_name: 'Vamja', email: 'parthvamja@gmail.com', password: 'password', password_confirmation: 'password')
user4.add_role('member')

user5 = User.create(first_name: 'Jigar', last_name: 'Patel', email: 'jigarpatel@gmail.com', password: 'password', password_confirmation: 'password')
user5.add_role('member')

# Adding More Users (30 More)
30.times do |i|
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  email = Faker::Internet.email
  password = 'password'

  user = User.create(
    first_name: first_name,
    last_name: last_name,
    email: email,
    password: password,
    password_confirmation: password
  )

  # Randomly assign 'member' or 'team_owner' role
  user.add_role('member')
end
