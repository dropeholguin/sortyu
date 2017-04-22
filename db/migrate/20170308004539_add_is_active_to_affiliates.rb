class AddIsActiveToAffiliates < ActiveRecord::Migration[5.0]
  def change
  	add_column :affiliates, :is_active, :boolean, default: false
  end
end
