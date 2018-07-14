class CreateSpaces < ActiveRecord::Migration[5.1]
  def change
    create_table :spaces do |t|
      t.string :name
      t.references :board, foreign_key: true, index: true
      t.string :result, default: ""
      t.integer :ship_id, index: true
    end
  end
end
