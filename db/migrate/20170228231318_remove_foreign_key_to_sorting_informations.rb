class RemoveForeignKeyToSortingInformations < ActiveRecord::Migration[5.0]
  def change
  	remove_reference :sorting_informations, :section
  	add_reference :sorting_informations, :section
  end
end
