ActiveAdmin.register User do

index do
	selectable_column
	id_column
	column :first_name
	column :last_name
	column :email
	column "Create Date", :created_at
	actions defaults: false do |user|
		if user.has_role? :reviewer
			link_to 'Remove reviewer', remove_reviewer_role_path(user), method: :patch, class: 'button'
		else
      link_to 'Reviewer', create_reviewer_role_path(user), method: :patch, class: 'button'
		end
  end
  actions defaults: false do |user|
		if user.is_active?
			link_to 'Suspend Account', suspend_account_path(user), method: :patch, class: 'button'
		else
      link_to 'Active Account', active_account_path(user), method: :patch, class: 'button'
		end
  end
  actions
end

filter :first_name
filter :last_name
filter :email
filter :created_at

end
