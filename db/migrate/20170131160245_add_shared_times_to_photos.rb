class AddSharedTimesToPhotos < ActiveRecord::Migration[5.0]
  def change
  	add_column :photos, :shared_times, :integer, default: 0
  end
end
