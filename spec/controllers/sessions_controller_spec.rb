require 'rails_helper'


RSpec.describe SessionsController, type: :controller do
describe "GET login" do
    it "returns a success response" do
      email = 'jliv316@gmail.com'
      password = 'password'

      get :new
      
      fill_in :email, with: email
      fill_in :password, with: password

      click_button 'Log In'

    end
  end
end

  