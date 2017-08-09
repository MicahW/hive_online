class AddUserId < ActiveRecord::Migration[5.1]
  def change
    add_column :friend_requests, :user_id, :integer
  end
end
