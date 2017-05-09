class AddTmpToPhotos < ActiveRecord::Migration[5.0]
  def change
    add_column :photos, :tmp, :boolean, default: true
  end
end
