class AddAboutYouToAffiliate < ActiveRecord::Migration[5.0]
  def change
  	add_column :affiliates, :about_you, :text
  end
end
