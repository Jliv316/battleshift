require 'rails_helper'

describe 'Registered User', type: :request do
  let(:user1) { create(:user) }
  let(:user2) { create(:user, api_key: User.generate_api_key) }
  context 'player 1 is logged in and activated' do
    it 'player 1 can create a new game by sending a post request with an API key and another players username and it will create two boards with spaces' do
      post "/api/v1/games", params: { game: { api_key: user1.api_key, player_2_username: user2.username } }

      game = Game.last
      expect(response.code).to eq("200")
      expect(game.player_1_id).to eq(user1) 
      expect(game.player_1_api_key).to eq(user1.api_key) 
      expect(game.player_2_id).to eq(user2) 
      expect(game.player_2_api_key).to eq(user2.api_key)

      board1 = Board.find_by(user_id: user1.id)
      board2 = Board.find_by(user_id: user2.id)
      expect(board1.game_id).to eq(game.id)
      expect(board2.game_id).to eq(game.id)
      expect(board1.spaces.first.name).to eq("A1")
      expect(board2.spaces.first.name).to eq("A1")
    end
  end
end
