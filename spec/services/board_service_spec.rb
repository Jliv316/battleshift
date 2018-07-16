require 'rails_helper'

describe BoardService do
  let(:user1) { create(:user) }
  let(:user2) { create(:user, api_key: User.generate_api_key) }
  let(:game) { create(:game, player_1_id: user1, player_2_id: user2, player_1_api_key: user1.api_key, player_2_api_key: user2.api_key) }
  it "exists when provided a user, game and length" do
    board = BoardService.create_board(user1, game, 4)
    expect(board).to be_a Board
  end
end