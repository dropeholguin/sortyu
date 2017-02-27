class AddCountFlagsToPhotos < ActiveRecord::Migration[5.0]
  def change
  	add_column :photos, :count_flags, :integer, default: 0
  end
end
