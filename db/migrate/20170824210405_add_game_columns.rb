class AddGameColumns < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :state, :string
    add_column :games, :turn, :integer
    add_column :users, :game_id, :integer
  end
end
