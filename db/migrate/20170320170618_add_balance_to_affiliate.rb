class AddBalanceToAffiliate < ActiveRecord::Migration[5.0]
  def change
  	add_column :affiliates, :balance_cents, :integer
  end
end
