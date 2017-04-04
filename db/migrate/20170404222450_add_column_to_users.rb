class AddColumnToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :hide_results, :boolean, default: false
  end
end
