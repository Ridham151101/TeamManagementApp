# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  # Validations
  it 'validates presence of first name' do
    user = User.new(last_name: 'Doe')
    expect(user).not_to be_valid
    expect(user.errors[:first_name]).to include("can't be blank")
  end

  it 'validates presence of last name' do
    user = User.new(first_name: 'John')
    expect(user).not_to be_valid
    expect(user.errors[:last_name]).to include("can't be blank")
  end

  # Associations
  it 'has many owned_teams' do
    user = User.new
    assoc = user.class.reflect_on_association(:owned_teams)
    expect(assoc.macro).to eq(:has_many)
    expect(assoc.options[:dependent]).to eq(:destroy)
    expect(assoc.options[:foreign_key]).to eq('user_id')
  end

  it 'has many memberships' do
    user = User.new
    assoc = user.class.reflect_on_association(:memberships)
    expect(assoc.macro).to eq(:has_many)
    expect(assoc.options[:dependent]).to eq(:destroy)
    expect(assoc.options[:foreign_key]).to eq('user_id')
  end

  it 'has many teams through memberships' do
    user = User.new
    assoc = user.class.reflect_on_association(:teams)
    expect(assoc.macro).to eq(:has_many)
    expect(assoc.options[:through]).to eq(:memberships)
  end

  # Password confirmation validation
  it 'validates password confirmation' do
    # Use the factory to create a user with valid password and confirmation
    user = create(:user, password: 'password123', password_confirmation: 'password123')
    expect(user).to be_valid
  
    # Set an invalid password confirmation
    user.password_confirmation = 'wrongpassword'
    expect(user).not_to be_valid
    expect(user.errors[:password_confirmation]).to include("doesn't match Password")
  end
end
