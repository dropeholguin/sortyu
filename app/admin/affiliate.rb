ActiveAdmin.register Affiliate do

action_item only: :show  do
  if affiliate.is_active?
    link_to 'Suspend Account', suspend_account_affiliate_path(affiliate), method: :patch, class: 'button'
  else
    link_to 'Active Account', active_account_affiliate_path(affiliate), method: :patch, class: 'button'
  end
end

show do
  attributes_table do
    row :first_name
    row :last_name
    row :username
    row :email
    row :is_active
    row :created_at
  end
  active_admin_comments
end

index do
	selectable_column
	id_column
	column :first_name
	column :last_name
	column :email
  column "Balance" do |affiliate|
    money_without_cents_and_with_symbol affiliate.balance_cents
  end
	column "Create Date", :created_at
  	actions
end

csv do
  column :first_name
  column :last_name
  column :email
  column "Balance" do |affiliate|
    money_without_cents_and_with_symbol affiliate.balance_cents
  end 
end

filter :first_name
filter :last_name
filter :email
filter :created_at

end
