require 'rails_helper'

describe BoardService do
  let(:user1) { create(:user) }
  let(:user2) { create(:user, api_key: User.generate_api_key) }
  let(:game) { create(:game, player_1_id: user1, player_2_id: user2, player_1_api_key: user1.api_key, player_2_api_key: user2.api_key) }

  it "exists when provided a user, game and length" do
    board = BoardService.create_board(user1, game, 4)
    board_array = ["A1", "A2", "A3", "A4", "B1", "B2", "B3", "B4", "C1", "C2", "C3", "C4", "D1", "D2", "D3", "D4"]
    expect(board).to eq(board_array)
  end

  it 'gets row letters' do
    board = BoardService.create_board(user1, game, 4)
    row_letters = BoardService.get_row_letters
    expect(row_letters).to eq(["A", "B", "C", "D"])
  end

  it 'gets column numbers' do
    board = BoardService.create_board(user1, game, 4)
    column_numbers = BoardService.get_column_numbers
    expect(column_numbers).to eq(["1", "2", "3", "4"])
  end

  it 'returns space names' do
    board = BoardService.create_board(user1, game, 4)
    space_names = BoardService.space_names
    expect(space_names).to eq(["A1", "A2", "A3", "A4", "B1", "B2", "B3", "B4", "C1", "C2", "C3", "C4", "D1", "D2", "D3", "D4"])
  end

  it 'determines if a space is occupied' do
    
  end
end