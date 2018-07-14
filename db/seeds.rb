# player_1_board = Board.new(4)
# player_2_board = Board.new(4)

# sm_ship = Ship.new(2)
# md_ship = Ship.new(3)

# # Place Player 1 ships
# ShipPlacer.new(board: player_1_board,
#                ship: sm_ship,
#                start_space: "A1",
#                end_space: "A2").run

# ShipPlacer.new(board: player_1_board,
#                ship: md_ship,
#                start_space: "B1",
#                end_space: "D1").run

# # Place Player 2 ships
# ShipPlacer.new(board: player_2_board,
#                ship: sm_ship.dup,
#                start_space: "A1",
#                end_space: "A2").run

# ShipPlacer.new(board: player_2_board,
#                ship: md_ship.dup,
#                start_space: "B1",
#                end_space: "D1").run

# game_attributes = {
#   player_1_board: player_1_board,
#   player_2_board: player_2_board,
#   player_1_turns: 0,
#   player_2_turns: 0,
#   current_turn: "challenger"
# }

# game = Game.new(game_attributes)
# game.save!

User.create!(first_name: 'Bob', last_name: 'Smith', username: 'New@gmail.com', password_digest: 'password', api_key: "zp279uiblahnw40sv8f1", activated: true)
User.create!(first_name: 'Sally', last_name: 'Smith', username: 'Newest@gmail.com', password_digest: 'password', api_key: "f5bx0in1w8cde347vqmr", activated: true)



# expect(game_data[:id]).to be_an Integer
# expect(game_data[:current_turn]).to be_a String
# expect(game_data[:player_1_board][:rows].count).to eq(board_size)
# expect(game_data[:player_2_board][:rows].count).to eq(board_size)
# expect(game_data[:player_1_board][:rows][0][:name]).to eq("row_a")
# expect(game_data[:player_1_board][:rows][3][:data][0][:coordinates]).to eq("D1")
# expect(game_data[:player_1_board][:rows][3][:data][0][:coordinates]).to eq("D1")
# expect(game_data[:player_1_board][:rows][3][:data][0][:status]).to be_a String

