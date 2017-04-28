class RemoveUrlToUsers < ActiveRecord::Migration[5.0]
  def change
  	remove_column :users, :url, :string, default: ""
  end
end
