class ChangeTopTypeInSections < ActiveRecord::Migration[5.0]
  def change
  	change_column :sections, :top, :decimal, precision:10, scale:3
  end
end
