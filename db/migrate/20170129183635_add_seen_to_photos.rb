class AddSeenToPhotos < ActiveRecord::Migration[5.0]
  def change
  	add_column :photos, :seen, :boolean, default: false
  end
end
