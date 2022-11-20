require 'rails_helper'

RSpec.describe User, type: :model do
  it 'will not accept user without email' do
    user = User.new(email: nil)
    expect(user).to_not be_valid
  end

  it 'will not accept user password' do
    user = User.new(password: nil)
    expect(user).to_not be_valid
  end
end
