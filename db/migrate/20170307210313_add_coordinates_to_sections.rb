class AddCoordinatesToSections < ActiveRecord::Migration[5.0]
  def change
  	add_column :sections, :top, :integer, default: 0
  	add_column :sections, :left, :integer, default: 0
  	add_column :sections, :width, :integer, default: 0
  	add_column :sections, :height, :integer, default: 0
  end
end
