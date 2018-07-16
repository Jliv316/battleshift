require 'rails_helper'
RSpec.describe NotificationController, type: :controller do
  let(:user1) { create(:user, activated: false) }

  describe "GET #create" do
    it "returns a success response" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user1)
      post :create

      expect(flash[:notice]).to be_present
      expect(response.code).to eq("302")
      expect(response).to redirect_to("/dashboard/#{user1.id}")
    end
  end
end