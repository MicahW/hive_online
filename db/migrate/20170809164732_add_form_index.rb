class AddFormIndex < ActiveRecord::Migration[5.1]
  def change
    add_index :friend_requests, :user_id
  end
end
