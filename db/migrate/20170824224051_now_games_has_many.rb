class NowGamesHasMany < ActiveRecord::Migration[5.1]
  def change
    remove_column :games, :user_id, :integer
    add_column :users, :game_id, :integer
  end
end
