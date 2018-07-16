require 'rails_helper'

describe "GET login" do
  let(:user){ create(:user) }
    it "returns a success response" do
      email = user.username
      password = user.password

      visit '/login'

      fill_in :session_email, with: email
      fill_in :session_password, with: password

      click_button 'Log In'
      expect(current_path).to eq("/dashboard/1")
  end
end

  