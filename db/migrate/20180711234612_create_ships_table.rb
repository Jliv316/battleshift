class CreateShipsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :ships do |t|
      t.integer :damage, default: 0
      t.integer :length
    end
  end
end
