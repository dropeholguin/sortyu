class UpdateForeignKeyToSections < ActiveRecord::Migration[5.0]
  def change
  	remove_reference :sections, :photo
  	add_reference :sections, :photo, foreign_key: true, on_delete: :cascade
  end
end
