class AddReferencesToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :friend_request, foreign_key: true
  end
end
