class ChangeTranslateXTypeInSections < ActiveRecord::Migration[5.0]
  def change
  	change_column :sections, :translateX, :decimal, precision:10, scale:3
  end
end
