class AddOpponentColumn < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :opponent_id, :integer
  end
end
