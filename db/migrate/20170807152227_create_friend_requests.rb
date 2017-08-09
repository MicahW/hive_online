class CreateFriendRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :friend_requests do |t|
      t.belongs_to :user, index: true
      t.timestamps
    end
  end
end
