require 'rails_helper'

describe 'Registered User', type: :request do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:user3) { create(:user, activated: false)}
  
  context 'player 1 is logged in and activated' do
    it 'player 1 can create a new game by sending a post request with an API key and another players username' do
      post "/api/v1/games", params: { game: { api_key: user1.api_key, player_2_username: user2.username } }

      expect(response.code).to eq("200")
      expect(Game.last.player_1_id).to eq(user1) 
      expect(Game.last.player_1_api_key).to eq(user1.api_key) 
      expect(Game.last.player_2_id).to eq(user2) 
      expect(Game.last.player_2_api_key).to eq(user2.api_key) 
    end

    it 'player 1 will receive a message if player 2 is not registered in the system' do
      post "/api/v1/games", params: { game: { api_key: user1.api_key, player_2_username: "example@example.com" } }

      json = JSON.parse(response.body)
      expect(response.code).to eq("400")
      expect(json["message"]).to eq("Your opponent must create an account before you can play a game. They can check their email for a registration link.")
    end
  end

  context 'player 1 is logged in but not activated' do
    it 'player 1 attempts to create a game and recieves a message to activate account' do
      post "/api/v1/games", params: { game: { api_key: user3.api_key, player_2_username: user2.username } }

      json = JSON.parse(response.body)
      expect(response.code).to eq("400")
      expect(json["message"]).to eq("You must activate your account before you can play a game. Check your email for another activation email.")
    end
  end
end