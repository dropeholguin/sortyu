class CreateSections < ActiveRecord::Migration[5.0]
  def change
    create_table :sections do |t|
    	t.boolean :rate_first
    	t.references :photo, foreign_key: true
      t.timestamps
    end
  end
end
