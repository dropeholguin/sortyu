class ChangeLeftTypeInSections < ActiveRecord::Migration[5.0]
  def change
  	change_column :sections, :left, :decimal, precision:10, scale:3
  end
end
