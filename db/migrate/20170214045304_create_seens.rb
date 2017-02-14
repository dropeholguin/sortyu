class CreateSeens < ActiveRecord::Migration[5.0]
  def change
    create_table :seens do |t|
    	t.boolean :seen,  default: false
    	t.references :user, index: true, foreign_key: true
    	t.references :photo, index: true, foreign_key: true
      t.timestamps
    end
  end
end
