class RemoveForeignKeyToSections < ActiveRecord::Migration[5.0]
  def change
  	remove_reference :sections, :photo
  	add_reference :sections, :photo
  end
end
