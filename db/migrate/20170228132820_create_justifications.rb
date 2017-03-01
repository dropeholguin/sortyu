class CreateJustifications < ActiveRecord::Migration[5.0]
  def change
    create_table :justifications do |t|
      t.string :title
      t.text :body
      t.references :user
      t.references :photo

      t.timestamps
    end
  end
end
