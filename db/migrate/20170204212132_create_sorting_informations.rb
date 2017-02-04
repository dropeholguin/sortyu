class CreateSortingInformations < ActiveRecord::Migration[5.0]
  def change
    create_table :sorting_informations do |t|
			t.integer :most_frequent
			t.float :average
			t.references :section, foreign_key: true
      t.timestamps
    end
  end
end
