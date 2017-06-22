class AddColorToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :color, :string, defualt: "orange"
  end
end
