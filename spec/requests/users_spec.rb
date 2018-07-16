require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users" do
    it "can visit the users index successfully" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(User.create!(first_name: 'Bob', last_name: 'Smith', username: 'Newestest@gmail.com', password_digest: 'password'))
      get users_path
      expect(response).to have_http_status(200)
    end

    # it 'redirects the user to a 404 page if they are not logged in' do
    #   allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(nil)

    #   get users_path
    #   require 'pry'; binding.pry
    #   expect(response).to have_http_status(404)
    # end
  end
end
