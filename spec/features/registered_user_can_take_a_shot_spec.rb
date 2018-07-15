require 'rails_helper'

describe 'Registered user', type: :request do
  before(:each) do
    @user1 = create(:user) 
    @user2 = create(:user, api_key: User.generate_api_key)
    @game = create(:game, player_1_id: @user1, player_2_id: @user2, player_1_api_key: @user1.api_key, player_2_api_key: @user2.api_key)
    BoardService.create_board(@user1, @game, 4)
    BoardService.create_board(@user2, @game, 4)
    @board1 = Board.all.first
    @board2 = Board.all.last
  end
  context 'after starting a game with another registered user' do
    context 'ships have been placed and player 1 takes a shot and hits player 2s ship' do
      it 'updates the message and board with a hit' do
        @user1 = create(:user) 
        @user2 = create(:user, api_key: User.generate_api_key)
        @game = create(:game, player_1_id: @user1, player_2_id: @user2, player_1_api_key: @user1.api_key, player_2_api_key: @user2.api_key)
        BoardService.create_board(@user1, @game, 4)
        BoardService.create_board(@user2, @game, 4)
        @board1 = Board.all.first
        @board2 = Board.all.last

        @ship1 = create(:ship)
        @ship2 = create(:ship, length: 3)
        @ship3 = create(:ship)
        @ship4 = create(:ship, length: 3)
        #player 1 places ships
        SpaceService.occupy!(@board1.spaces[0], @ship1)
        SpaceService.occupy!(@board1.spaces[1], @ship1)

        SpaceService.occupy!(@board1.spaces[4], @ship2)
        SpaceService.occupy!(@board1.spaces[5], @ship2)
        SpaceService.occupy!(@board1.spaces[6], @ship2)
        #player2 places ships
        SpaceService.occupy!(@board2.spaces[1], @ship3)
        SpaceService.occupy!(@board2.spaces[0], @ship3)

        SpaceService.occupy!(@board2.spaces[4], @ship4)
        SpaceService.occupy!(@board2.spaces[5], @ship4)
        SpaceService.occupy!(@board2.spaces[6], @ship4)

        #player 2 takes a shot and hits
        payload = {target: "A1"}
        endpoint = "/api/v1/games/#{@game.id}/shots" 

        post endpoint, params: payload, headers: {"HTTP_X_API_KEY" => @user2.api_key}

        game_data = JSON.parse(response.body, symbolize_names: true)

        expect(game_data[:message]).to eq("Your shot resulted in a Hit.")
        expect(game_data[:player_1_board][:rows][0][:data][0][:status]).to eq("Hit")
        expect(@board1.ships.first.damage).to eq(1)
      end

      it "updates the message but not the board with invalid coordinates" do
        @user1 = create(:user) 
        @user2 = create(:user, api_key: User.generate_api_key)
        @game = create(:game, player_1_id: @user1, player_2_id: @user2, player_1_api_key: @user1.api_key, player_2_api_key: @user2.api_key)
        BoardService.create_board(@user1, @game, 4)
        BoardService.create_board(@user2, @game, 4)
        @board1 = Board.all.first
        @board2 = Board.all.last
        
        payload = {target: "B1"}
        endpoint = "/api/v1/games/#{@game.id}/shots" 

        post endpoint, params: payload, headers: {"HTTP_X_API_KEY" => @user2.api_key}

        game_data = JSON.parse(response.body, symbolize_names: true)

        expect(game_data[:message]).to eq "Your shot resulted in a Miss."
      end
    end
  end
end
