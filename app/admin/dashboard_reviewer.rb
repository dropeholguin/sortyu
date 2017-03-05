ActiveAdmin.register_page "Dashboard", namespace: :admin_reviewer do
	menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

	content title: proc{ I18n.t("active_admin.dashboard") } do
		columns do
	   		column do
	            panel "Justifications" do
	                ul do
	                    table_for Justification.order("created_at desc") do
	                        column "Photo" do |justification|
	                            image_tag justification.photo.file.url(:thumb)
	                        end
	                        column :title
	                        column :body
	                        column "Create Date", :created_at
	                    end

	                    table_for Flag.order("created_at desc") do
	                    	column :reason
	                    end
	                end
	            end
	        end
	    end
  	end
end
