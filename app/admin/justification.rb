ActiveAdmin.register Justification do

show do
  attributes_table do
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
	column "Justification", :body
	column "Photo" do |justification|
  	link_to(image_tag(justification.photo.file.url(:thumb)), admin_photo_path(justification.photo))
	end
  column "Create Date", :created_at

  column "User photo" do |justification|
    if justification.photo.user.is_active?
      link_to 'Suspend Account', suspend_account_path(justification.photo.user), method: :patch, class: 'button'
    else
      link_to 'Active Account', active_account_path(justification.photo.user), method: :patch, class: 'button'
    end
  end
  actions defaults: false do |justification|
  if justification.photo.suspended == true
      link_to 'Allow', approve_path(justification.photo), method: :patch, class: 'button'
    end
  end
	actions defaults: false do |justification|
    link_to "Delete", admin_justification_path(justification), method: :delete, data: { confirm: "Are you sure?" }, class: 'button'
  end
end

filter :created_at
end
