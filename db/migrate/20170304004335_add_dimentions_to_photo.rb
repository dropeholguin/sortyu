class AddDimentionsToPhoto < ActiveRecord::Migration[5.0]
  def change
  	add_column :photos, :dimentions, :string, limit: 30
  end
end
