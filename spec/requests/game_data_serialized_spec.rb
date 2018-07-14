require 'rails_helper'

describe 'Registered user', type: :request do
  before(:each) do
    @user1 = create(:user) 
    @user2 = create(:user)
    @game = create(:game, player_1_id: @user1, player_2_id: @user2, player_1_api_key: @user1.api_key, player_2_api_key: @user2.api_key)
    @board1 = create(:board, user: @user1, game: @game) 
    @board2 = create(:board, user: @user2, game: @game) 
    create_spaces(@board1)
    create_spaces(@board2)
  end
    context 'user places ship' do
      it 'serializes response' do
      payload = { ship_size: 3, start_space: "A1", end_space: "A3" }
      endpoint = "/api/v1/games/#{@game.id}/ships"

      post endpoint, params: payload, headers: {"HTTP_X_API_KEY" => @user2.api_key}

      game_data = JSON.parse(response.body, symbolize_names: true)

      expect(game_data[:id]).to be_an Integer
      expect(game_data[:current_turn]).to be_a String
      expect(game_data[:player_1_board][:rows].count).to eq(board_size)
      expect(game_data[:player_2_board][:rows].count).to eq(board_size)
      expect(game_data[:player_1_board][:rows][0][:name]).to eq("row_a")
      expect(game_data[:player_1_board][:rows][3][:data][0][:coordinates]).to eq("D1")
      expect(game_data[:player_1_board][:rows][3][:data][0][:coordinates]).to eq("D1")
      expect(game_data[:player_1_board][:rows][3][:data][0][:status]).to be_a String
    end
  end
end