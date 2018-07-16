require 'rails_helper'

RSpec.describe "users/index", type: :view do
  before(:each) do
    assign(:users, [
      User.create!(first_name: 'Bob', last_name: 'Smith', username: 'Newerer@gmail.com', password_digest: 'password'),
      User.create!(first_name: 'Sally', last_name: 'Smith', username: 'Newestestest@gmail.com', password_digest: 'password2')
    ])
  end

  it "renders a list of users" do
    render
    
    expect(response).to have_text(User.first.first_name)
    expect(response).to have_text(User.first.last_name)
    expect(response).to have_text(User.first.username)
    expect(response).to have_text(User.all[1].first_name)
    expect(response).to have_text(User.all[1].last_name)
    expect(response).to have_text(User.all[1].username)
  end
end
