class AddDraftToPhotos < ActiveRecord::Migration[5.0]
  def change
  	add_column :photos, :draft, :boolean, default: true
  end
end
