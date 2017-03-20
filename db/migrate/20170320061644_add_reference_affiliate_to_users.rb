class AddReferenceAffiliateToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_reference :users, :affiliate, index: true
  end
end
