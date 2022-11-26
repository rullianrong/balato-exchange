require 'rails_helper'

RSpec.describe User, type: :model do
  it 'accepts new unconfirmed user' do
    user = User.new
    expect(user.confirmed_at).to eq(nil)
    expect(user.admin).to eq(false)
  end

  it 'accepts a valid user' do
    user = build(:user)
    expect(user).to be_valid
  end

  it 'will not accept user without password' do
    user = build(:user, password: nil)
    expect(user).to_not be_valid
  end

  it 'accepts user as trader' do
    user = build(:user)
    expect(user.admin).to eq(false)
  end

  it 'accepts user as admin' do
    user = build(:admin_user)
    expect(user.admin).to eq(true)
  end

  it 'accepts confirmed user and admin' do
    user = build(:user)
    expect(user.confirmed_at).not_to eq(nil) 
    admin = build(:admin_user)
    expect(admin.confirmed_at).not_to eq(nil) 
  end
end