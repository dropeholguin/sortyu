class RenameLikesToSorting < ActiveRecord::Migration[5.0]
  def change
  	rename_table :likes, :sortings
  end
end
