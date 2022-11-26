require 'rails_helper'

RSpec.describe "Admin::Users", type: :request do
  setup do
    sign_in(:admin_user)
  end

  describe "GET /admin/users" do
    it "works! (now write some real specs)" do
      get admin_users_path
      expect(response).to have_http_status(200)
    end
  end
end
