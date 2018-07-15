require 'rails_helper'

describe 'Registered user', type: :request do
  before(:each) do
    @user1 = create(:user) 
    @user2 = create(:user, api_key: User.generate_api_key)
    @game = create(:game, player_1_id: @user1, player_2_id: @user2, player_1_api_key: @user1.api_key, player_2_api_key: @user2.api_key)
    @board1 = create(:board, user: @user1, game: @game) 
    @board2 = create(:board, user: @user2, game: @game) 
    create_spaces(@board1)
    create_spaces(@board2)
  end

  context 'after starting a game with another registered user' do
    it 'the user can send a request to the ship placing endpoint and place a ship' do
      payload = { ship_size: 2, start_space: "B1", end_space: "C1" }
      endpoint = "/api/v1/games/#{@game.id}/ships"

      post endpoint, params: payload, headers: {"HTTP_X_API_KEY" => @user1.api_key}

      data = JSON.parse(response.body)

      expect(data["message"]).to eq("Successfully placed ship with a size of 2. You have 1 ship(s) to place with a size of 3.")
      expect(@board1.spaces.find_by(name: "C1").ship_id).to eq(Ship.first.id)
      expect(@board1.spaces.find_by(name: "B1").ship_id).to eq(Ship.first.id)
      expect(@board1.spaces.find_by(name: "B1").ship_id).to_not eq(2)
      expect(@board1.spaces.find_by(name: "C1").ship_id).to_not eq(2)
    end

    it 'user will recieve an error upon attempting to place a ship on an occupied space' do
      payload = { ship_size: 2, start_space: "B1", end_space: "C1" }
      endpoint = "/api/v1/games/#{@game.id}/ships"

      post endpoint, params: payload, headers: {"HTTP_X_API_KEY" => @user1.api_key}

      data = JSON.parse(response.body)

      expect(data["message"]).to eq("Successfully placed ship with a size of 2. You have 1 ship(s) to place with a size of 3.")
    end

    it 'the user can send another request to the ship placing endpoint and place the last ship' do
      ship = Ship.create!(id: 1115)
      @board1.spaces.first.update(ship_id: ship.id)
      @board1.spaces.last.update(ship_id: ship.id)
      payload = { ship_size: 3, start_space: "A2", end_space: "A4" }
      endpoint = "/api/v1/games/#{@game.id}/ships"

      post endpoint, params: payload, headers: {"HTTP_X_API_KEY" => @user1.api_key}

      data = JSON.parse(response.body)

      expect(data["message"]).to eq("Successfully placed ship with a size of 3. You have 0 ship(s) to place.")
      expect(@board1.spaces.find_by(name: "A2").ship_id).to eq(Ship.first.id)
      expect(@board1.spaces.find_by(name: "A3").ship_id).to eq(Ship.first.id)
      expect(@board1.spaces.find_by(name: "A4").ship_id).to eq(Ship.first.id)
      expect(@board1.spaces.find_by(name: "A2").ship_id).to_not eq(6)
      expect(@board1.spaces.find_by(name: "A3").ship_id).to_not eq(6)
      expect(@board1.spaces.find_by(name: "A4").ship_id).to_not eq(6)
    end

    it 'opponent can now place ships' do 
      payload = { ship_size: 3, start_space: "D1", end_space: "D3" }
      endpoint = "/api/v1/games/#{@game.id}/ships"

      post endpoint, params: payload, headers: {"HTTP_X_API_KEY" => @user2.api_key}

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:message]).to eq("Successfully placed ship with a size of 3. You have 1 ship(s) to place with a size of 2.")
      expect(@board2.spaces.find_by(name: "D1").ship_id).to eq(Ship.last.id)
      expect(@board2.spaces.find_by(name: "D2").ship_id).to eq(Ship.last.id)
      expect(@board2.spaces.find_by(name: "D3").ship_id).to eq(Ship.last.id)
      expect(@board2.spaces.find_by(name: "D1").ship_id).to_not eq(6)
      expect(@board2.spaces.find_by(name: "D2").ship_id).to_not eq(6)
      expect(@board2.spaces.find_by(name: "D3").ship_id).to_not eq(6)
    end

    it 'opponent can place remaining ship' do 
      ship = Ship.create!(id: 1115)
      @board2.spaces.first.update(ship_id: ship.id)
      @board2.spaces.last.update(ship_id: ship.id)
      @board2.spaces[1].update(ship_id: ship.id)
      payload = { ship_size: 2, start_space: "B2", end_space: "B3" }
      endpoint = "/api/v1/games/#{@game.id}/ships"

      post endpoint, params: payload, headers: {"HTTP_X_API_KEY" => @user2.api_key}

      data = JSON.parse(response.body)

      expect(data["message"]).to eq("Successfully placed ship with a size of 2. You have 0 ship(s) to place.")
      expect(@board2.spaces.find_by(name: "B2").ship_id).to eq(Ship.first.id)
      expect(@board2.spaces.find_by(name: "B3").ship_id).to eq(Ship.first.id)
      expect(@board2.spaces.find_by(name: "B2").ship_id).to_not eq(6)
      expect(@board2.spaces.find_by(name: "B3").ship_id).to_not eq(6)
    end
  end

  context 'players have deployed ships' do
    it 'player 1 takes shot and recieves an error message telling player 1 it is not his/her turn' do
      payload = {target: "A1"}
      endpoint = "/api/v1/games/#{@game.id}/shots"

      post endpoint, params: payload, headers: {"HTTP_X_API_KEY" => @user1.api_key}

      game_data = JSON.parse(response.body, symbolize_names: true)

      expect(game_data[:message]).to include("Your shot resulted in a Miss.")

    end
  end
end
