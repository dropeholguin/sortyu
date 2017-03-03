class AddCountOfSortsToPhoto < ActiveRecord::Migration[5.0]
  def change
	add_column :photos, :count_of_sorts, :integer, default: 0
  end
end
