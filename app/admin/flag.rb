ActiveAdmin.register Flag do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :reason

index do
	selectable_column
	column :reason
	column "Create Date", :created_at
	actions
end

filter :created_at

end
