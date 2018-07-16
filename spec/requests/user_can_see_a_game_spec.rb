require 'rails_helper'

describe 'GET /api/v1/games/1' do
  context 'with an existing game' do
    it 'returns a game with boards' do
      @user1 = create(:user) 
      @user2 = create(:user, api_key: User.generate_api_key)
      @game = create(:game, player_1_id: @user1, player_2_id: @user2, player_1_api_key: @user1.api_key, player_2_api_key: @user2.api_key)
      @board1 = create(:board, user: @user1, game: @game) 
      @board2 = create(:board, user: @user2, game: @game) 
      create_spaces(@board1)
      create_spaces(@board2)

      get "/api/v1/games/#{@game.id}"

      actual  = JSON.parse(response.body, symbolize_names: true)
      expected = Game.last

      expect(response).to be_success
      expect(actual[:id]).to eq(expected.id)
      expect(actual[:current_turn]).to eq(expected.current_turn)
      expect(actual[:player_1_board][:rows].count).to eq(4)
      expect(actual[:player_2_board][:rows].count).to eq(4)
      expect(actual[:player_1_board][:rows][0][:name]).to eq("row_a")
      expect(actual[:player_1_board][:rows][3][:data][0][:coordinates]).to eq("D1")
      expect(actual[:player_1_board][:rows][3][:data][0][:coordinates]).to eq("D1")
      expect(actual[:player_1_board][:rows][3][:data][0][:status]).to eq("")
    end
  end

  describe 'with no game' do
    it 'returns a 400' do
      get "/api/v1/games/1"

      expect(response.status).to be(404)
    end
  end
end
