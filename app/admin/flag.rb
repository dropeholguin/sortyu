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
	actions defaults: false do |flag|
    link_to 'View', admin_flag_path(flag), class: 'button'
  end
  actions defaults: false do |flag|
    link_to "Delete", admin_flag_path(flag), method: :delete, data: { confirm: "Are you sure?" }, class: 'button'
  end
end

filter :created_at

end
