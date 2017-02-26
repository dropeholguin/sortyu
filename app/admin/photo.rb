ActiveAdmin.register Photo do

show do
  attributes_table do
    row :description
 		row :user
    row :file do |photo|
      image_tag photo.file.url(:thumb)
    end
    row :state
    row :created_at
  end
  active_admin_comments
end

index do
	selectable_column
	column :description
	column "Photo" do |photo|
  	image_tag photo.file.url(:thumb)
	end
	column :user
	column "Create Date", :created_at
	actions defaults: false do |photo|
    link_to 'View', admin_photo_path(photo), class: 'button'
  end
end

filter :created_at

end
