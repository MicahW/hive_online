class AddWhiteId < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :white_id, :interger
  end
end
