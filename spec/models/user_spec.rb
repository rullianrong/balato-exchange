require 'rails_helper'

RSpec.describe User, type: :model do
  it 'accepts a valid user' do
    user = build(:user)
    expect(user).to be_valid
  end

  it 'will not accept user without password' do
    user = build(:user, password: nil)
    expect(user).to_not be_valid
  end
end
