ActiveAdmin.register_page "Dashboard", namespace: :admin do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    columns do
        column do
            panel "Recent Flags" do
                ul do
                    table_for Flag.order("created_at desc").limit(5) do
                        column :reason
                        column "Photo" do |flag|
                            link_to(image_tag(flag.photo.file.url(:thumb)), admin_photo_path(flag.photo))
                        end
                        column "CREATE DATE", :created_at
                    end
                    strong { link_to "View All Flags", admin_flags_path, class: 'button' }
                end
            end
        end
        column do
            panel "Recent Affiliates" do
                ul do
                    table_for Affiliate.order("created_at desc").limit(5) do
                        column :first_name
                        column :last_name
                        column :username
                        column :email
                        column "CREATE DATE", :created_at
                    end
                    strong { link_to "View All Affiliates", admin_affiliates_path }
                end
            end
        end
    end

    columns do
        column do
            panel "Photos with more than 2 flags" do
                ul do
                    table_for Photo.where("count_flags >= ? ", 2).each do
                        column "Photo" do |photo|
                            link_to(image_tag(photo.file.url(:thumb)), admin_photo_path(photo))
                        end
                        column :description
                        column "User" do |photo|
                            link_to photo.user.full_name, admin_user_path(photo.user), class: 'button'
                        end
                    end
                end
            end
        end
    end
    columns do
        column do
            panel "Recent Justifications" do
                ul do
                    table_for Justification.order("created_at desc").limit(5) do
                        column "Photo" do |justification|
                            image_tag justification.photo.file.url(:thumb)
                        end
                        column :body
                        column "Create Date", :created_at
                    end
                    strong { link_to "View All Justifications", admin_justifications_path, class: 'button' }
                end
            end
        end
    end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
