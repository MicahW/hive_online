class CreateFriends < ActiveRecord::Migration[5.1]
  def change
    create_table :friends do |t|
      t.integer :user_id
      t.belongs_to :user
      t.timestamps
    end
  end
end
