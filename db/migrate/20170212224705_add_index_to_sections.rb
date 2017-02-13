class AddIndexToSections < ActiveRecord::Migration[5.0]
  def change
  	add_column :sections, :index, :integer
  end
end
