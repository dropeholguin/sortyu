ActiveAdmin.register Flag do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :reason

show do
  attributes_table do
    row :reason
    row :user
    row :photo do |flag|
      link_to(image_tag(flag.photo.file.url(:thumb)), admin_photo_path(flag.photo))
    end
    row :created_at
  end
  active_admin_comments
end

index do
	selectable_column
	column :reason
	column "Create Date", :created_at
	column "Photo" do |flag|
  	link_to(image_tag(flag.photo.file.url(:thumb)), admin_photo_path(flag.photo))
	end
	actions
end

filter :created_at

end
