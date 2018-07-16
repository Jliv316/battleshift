require 'rails_helper'
RSpec.describe SessionsController, type: :controller do
  let(:user1) { create(:user, activated: false) }

  describe "GET #new" do
    it "returns a success response" do
      get :new

      expect(response.code).to eq("200")
    end
  end

  describe "POST #create" do
    it 'returns a success response and redirects to the dashboard' do
      result = post :create, params: { session: { email: user1.username } }

      expect(request.session[:id]).to eq(user1.id)
      expect(result).to redirect_to("/dashboard/#{user1.id}")
    end
  end

  describe "DELETE #destroy" do
    it 'should log the user out' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user1)

      delete :destroy

      expect(request.session[:id]).to be_nil
    end
  end
end