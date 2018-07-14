class ChangeSpaces < ActiveRecord::Migration[5.1]
  def change
    remove_column :spaces, :ship_id, :integer
    add_reference :spaces, :ship, index: true 
  end
end
