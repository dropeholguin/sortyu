class RemoveForeignKeyToSeens < ActiveRecord::Migration[5.0]
  def change
  	remove_reference :seens, :photo
  	add_reference :seens, :photo
  end
end
