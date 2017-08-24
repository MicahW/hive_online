class IdOnUser < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :user_id, :integer
    remove_column :users, :game_id
  end
end
