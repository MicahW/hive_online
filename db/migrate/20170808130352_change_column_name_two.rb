class ChangeColumnNameTwo < ActiveRecord::Migration[5.1]
  def change
    rename_column :friend_requests, :user_id, :from_id
  end
end
