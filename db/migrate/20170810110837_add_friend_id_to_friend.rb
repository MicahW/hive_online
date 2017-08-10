class AddFriendIdToFriend < ActiveRecord::Migration[5.1]
  def change
    add_column :friends, :friend_id, :integer
  end
end
