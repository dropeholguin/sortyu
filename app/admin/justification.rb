ActiveAdmin.register Justification do

show do
  attributes_table do
    row :title
    row :body
    row :photo do |justification|
      link_to(image_tag(justification.photo.file.url(:thumb)), admin_photo_path(justification.photo))
    end
    row :created_at
  end
  active_admin_comments
end

index do
	selectable_column
	column :title
	column :body
	column "Photo" do |justification|
  	link_to(image_tag(justification.photo.file.url(:thumb)), admin_photo_path(justification.photo))
	end
	column "Create Date", :created_at
	actions
end

filter :created_at
filter :title
end
