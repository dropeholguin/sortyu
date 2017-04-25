class AddRefToAffiliates < ActiveRecord::Migration[5.0]
  def change
  	add_column :affiliates, :ref, :string
  end
end
