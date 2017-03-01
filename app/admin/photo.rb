ActiveAdmin.register Photo do

controller do
  def destroy
    @photo = Photo.find(params[:id])
    ModelMailer.remove_photo(@photo).deliver
    destroy!{ admin_photos_path }
  end
end

action_item only: :show  do
  if photo.suspended == false
    link_to 'Suspend Photo', suspend_path(photo), method: :patch, class: 'button'
  else
    link_to 'Approve Photo', approve_path(photo), method: :patch, class: 'button'
  end
end

show do
  attributes_table do
    row :description
 		row :user
    row :file do |photo|
      image_tag photo.file.url(:thumb)
    end
    row :suspended
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
