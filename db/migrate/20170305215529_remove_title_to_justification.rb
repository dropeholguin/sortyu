class RemoveTitleToJustification < ActiveRecord::Migration[5.0]
  def change
  	remove_column :justifications, :title
  end
end
