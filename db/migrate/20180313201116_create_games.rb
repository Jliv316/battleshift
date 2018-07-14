class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.text :player_1_board
      t.text :player_2_board
      t.string :winner, default: nil
      t.integer :player_1_turns, default: 0
      t.integer :player_2_turns, default: 0
      t.string :current_turn, default: ""

      t.timestamps
    end
  end
end
