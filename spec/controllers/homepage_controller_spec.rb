require 'rails_helper'
RSpec.describe HomepageController, type: :controller do
  let(:user1) { create(:user, activated: false) }

  describe "GET #show" do
    it "returns a success response" do
      get :show
      
      expect(response.code).to eq("200")
    end
  end
end