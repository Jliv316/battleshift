require 'rails_helper'

describe BoardService do
  @user1 = create(:user) 
  @user2 = create(:user, api_key: User.generate_api_key)
  @game = create(:game, player_1_id: @user1, player_2_id: @user2, player_1_api_key: @user1.api_key, player_2_api_key: @user2.api_key)
  board = BoardService.create_board(@user1, @game, 4)
  let(:board) { Board.new(4) }
  let(:ship)  { double(length: 2) }
  subject     { ShipPlacer.new(board: board, ship: ship, start_space: "A1", end_space: "A2") }

  it "exists when provided a user, game and length" do
    expect(board).to be_a Board
  end
end