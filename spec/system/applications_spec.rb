require 'rails_helper'

RSpec.describe "Applications", type: :system do
  before do
    driven_by(:selenium)
  end

  def login_user
    visit new_user_session_path
    authorized_user = create(:user)
    # filled with authorized credentials
    fill_in 'user_email', :with => authorized_user.email
    fill_in 'user_password', :with => authorized_user.password
    click_button "Log in"

    authorized_user
  end

  it "register a new user" do
    user = build(:user)

    visit new_user_registration_path
    fill_in 'user_email', :with => user.email
    fill_in 'user_password', :with => user.password
    fill_in 'user_password_confirmation', :with => user.password
    click_button "Sign up"

    expect(current_path).to eq(unauthenticated_root_path)
    expect(page).to have_text("A message with a confirmation link has been sent to your email address.")
  end

  it "will not allow unauthorized user" do

    visit new_user_session_path
    fill_in 'user_email', :with => "unauthorized@email.com"
    fill_in 'user_password', :with => "unauthorizedPassword"
    click_button "Log in"

    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_text("Invalid Email or password.")
  end

  it "login an authorized user" do
    login_user()

    expect(current_path).to eq(authenticated_root_path)
    expect(page).to have_text("Signed in successfully.")
  end

  it "searchs Microsoft stocks and buy some shares" do
    login_user()

    fill_in "symbol", :with => "MSFT"
    click_button "Search Stock"

    expect(page).to have_text("Microsoft Corporation (MSFT)")

    fill_in "Enter number of shares", :with => 100   
    click_button "Buy"

    expect(current_path).to eq(authenticated_root_path)
    expect(page).to have_text("Transaction successful!")
  end

  it "check user's transactions" do
    login_user()

    click_link "Transactions"
    expect(current_path).to eq("/transactions")
  end

  it 'change users login details' do 
    user = login_user()

    click_link "Manage Account"

    fill_in 'user_password', :with => 'newPassword'
    fill_in 'user_password_confirmation', :with => 'newPassword'
    fill_in 'user_current_password', :with =>  user.password

    click_button 'Update'
  end
end
