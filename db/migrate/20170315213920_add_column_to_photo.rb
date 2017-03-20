class AddColumnToPhoto < ActiveRecord::Migration[5.0]
  def change
  	add_column :photos, :first_edit, :boolean, default: true
  end
end
