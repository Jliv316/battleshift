require 'rails_helper'
RSpec.describe NotificationController, type: :controller do
  let(:user1) { create(:user, activated: false) }

  describe "GET #create" do
    it "returns a success response" do
      post :create

      expect(flash[:notice]).to be_present
      expect(result).to redirect_to("/dashboard/#{user1.id}")
    end
  end
end