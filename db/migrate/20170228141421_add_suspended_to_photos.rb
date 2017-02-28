class AddSuspendedToPhotos < ActiveRecord::Migration[5.0]
  def change
  	add_column :photos, :suspended, :boolean, default: false
  end
end
