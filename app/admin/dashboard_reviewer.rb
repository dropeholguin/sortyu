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
	                        column "Flags" do |justification|
	                            table_for Flag.where(photo: justification.photo) do
	                    			column :reason
	                    		end
	                        end
	                        column "Justification", :body
	                        column "Create Date", :created_at
	  	                    column " " do |justification|
	                            if justification.photo.suspended == true
							    	link_to 'Approve Photo', approve_path(justification.photo), method: :patch, class: 'button'
							  	end
	                        end 
	                    end    
	                end
	            end
	        end
	    end
  	end
end
