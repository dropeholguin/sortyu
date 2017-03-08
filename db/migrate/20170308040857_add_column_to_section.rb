class AddColumnToSection < ActiveRecord::Migration[5.0]
  def change
  	add_column :sections, :translateX, :integer, default: 0
  	add_column :sections, :translateY, :integer, default: 0
  end
end
