class PhotosController < ApplicationController
    before_action :set_photo, only: [:show, :edit, :update, :destroy, :shared_times, :like, :unlike]
    before_filter :authenticate_user!
    # GET /photos
    # GET /photos.json
    def index
        @user = current_user
        respond_to do |format|
            format.html
            format.js
        end
        #@photos = Photo.paginate(page: params[:page], per_page: 1).photos_sorting(@user.id)
    end

    def followings_photos
        @user = current_user
        @photos_ids = []
        @user.following.each do |following|
            following_photos = Photo.following_photos(following.id).order(state: :desc)
            following_photos.each do |photo|
                @photos_ids << photo.id
            end
        end
        respond_to do |format|
            format.json  { render json: { photos: @photos_ids } }
        end
    end

    def photos_draft
        @photos = Photo.photos_draft(current_user).order("created_at desc")
    end

    def remove_photos
        @photos = Photo.photos(current_user).order('created_at desc')
    end

    def pay_multiple_photos
        @photos = Photo.photos(current_user).order('created_at desc')
    end

    def change_draft_photos
        @user = current_user
        photo_ids_array = params[:photo_ids]
        photo_ids_array.each do | id_photo|
            photo = Photo.find(id_photo.to_i)
            photo.update_attributes draft: false
        end
        respond_to do |format|
            format.html { redirect_to profile_show_path, notice: "" }
        end
    end

    def pay_upload_process
        @photos = []
        photo_ids_array = cookies[:pay_photos].split("-")
        photo_ids_array.each do | id_photo|
            @photos << Photo.find(id_photo.to_i)
        end
    end

    def select_photos 
        @user = current_user
        @photos = []
        photo_ids_array = cookies[:import_queue].split("-")
        photo_ids_array.each do | id_photo|
            @photos << Photo.find(id_photo.to_i)
        end
        @number_photos = (10 - Photo.tmp_photos(@user.id).count)      
    end    

    def pay_photos
        respond_to do |format|
            photo_ids_array = params[:photo_ids_no_selected]
            photos = []
            if !photo_ids_array.nil?
                photo_ids_array.each do | id_photo|
                    photo = Photo.find(id_photo.to_i)
                    if photo.tmp == true
                       photos << photo 
                    end         
                end
            end
            photo_ids_array = photos.pluck(:id)
            photo_array_string = photo_ids_array.join("-")
            cookies[:remove_photos] = { value: photo_array_string, expires: 23.hours.from_now }

            photo_ids_array = params[:photo_ids]
            photo_array_string = photo_ids_array.join("-")
            cookies[:pay_photos] = { value: photo_array_string, expires: 23.hours.from_now }

            format.html { redirect_to new_charge_path }
        end
    end

    def upload_photos
        respond_to do |format|
            @user = current_user
            number_photos = (10 - Photo.tmp_photos(@user.id).count)
            if number_photos == params[:photo_ids].count
                photo_ids_array = params[:photo_ids_no_selected]
                photo_array_string = photo_ids_array.join("-")
                cookies[:tmp_pay_photos] = { value: photo_array_string, expires: 23.hours.from_now }
                
                photo_ids_array = params[:photo_ids]
                first_photo_id = photo_ids_array.shift
                photo_array_string = photo_ids_array.join("-")
                cookies[:import_queue] = { value: photo_array_string, expires: 23.hours.from_now }
                cookies[:first_imported_photo_id] = { value: first_photo_id, expires: 23.hours.from_now }

                format.html { 
                    redirect_to edit_photo_path(first_photo_id), notice: 'Photo was successfully created.'
                }
            else
                format.html { 
                    redirect_to :back, alert: 'Select only ' + number_photos.to_s
                }
            end 
        end
    end

    def sort_friend
        @photo = Photo.find(params[:id])
        seens = []
        @photo.seens.each do |seen|
            seens << seen.user_id
        end
        @seen = seens.include?(current_user.id)

        if @seen == true
            respond_to do |format|
                format.html { redirect_to profile_show_path}
            end
        end

        if current_user == @photo.user
            respond_to do |format|
                format.html { redirect_to photo_path(@photo), error: "You can't sort your own image."}
            end
        end
    end
    
    def load_photo_to_sort
        respond_to do |format|
            @photo = Photo.find(params[:photo_id])
            if @photo.nil?
                format.html { redirect_to root_path, error: "No more photos to sort"}
            end
            if @photo.seen?
                format.html { redirect_to root_path, error: "You can't sort already seen images." }
            else
                format.js
            end
        end
    end

    def load_sorting_stats
        respond_to do |format|
            @photo = Photo.find(params[:photo_id])
            format.js
        end
    end


    def reaload_photos_queue
        cookies[:photos_queue] = ""
        if !params[:photos_ids].nil?
            followings_photos = []
            params[:photos_ids][:photos].each do |photo_id|
                photo = Photo.find photo_id.to_i
                followings_photos << photo
            end
            photos = followings_photos
        else
            photos = Photo.photos_sorting(current_user.id).order(state: :desc)
        end
        photos_ids = []
        photos.each do |photo|
            if photo.seens.present?
                state = false
                photo.seens.each do |seen|
                    if seen.user_id == current_user.id
                        state = true
                    end
                end
                if state == false
                    photos_ids << photo
                end
            elsif photo.seens.empty?
                photos_ids << photo
            end
        end
        photo_ids_array = photos_ids.pluck(:id)
        if photo_ids_array.empty?
            render js: "window.location = #{root_path.to_json}"
            flash[:notice] = "You have sorted all images. Please try again later."
        else
            photo_array_string = photo_ids_array.join("-")
            cookies[:photos_queue] = { value: photo_array_string, expires: 23.hours.from_now }
            head :ok
        end
    end

    def update_photo_to_sorted_state
        @photo = Photo.find(params[:photo_id])
        @photo.update_attributes(count_of_sorts: @photo.count_of_sorts + 1)
        @seen = Seen.new(seen: true, user_id: current_user.id, photo_id: @photo.id)
        @seen.save
        head :ok
    end

    def create_sortings
        photo = Photo.find(params[:photo_id])
        if params[:sortings]
            params[:sortings].each_with_index do |sort, index|
                section = photo.sections.detect {|sect| sect.index == (index + 1) }
                @sorting = Sorting.new(order: sort, user_id: current_user.id, section_id: section.id)
                @sorting.save
            end
        end
        head :ok
    end

    def create_sections
        max_rectangles = params[:rectangles].to_i - 1
        @photo = Photo.find(params[:photo_id])

        if @photo.sections.empty?
            (0..max_rectangles).each do |i|
                @section = Section.new(photo_id: @photo.id, index: i)        
                @section.save
            end
        end
        head :ok
    end

    def info_sorting
        @photo = Photo.find(params[:photo_id])
        @photo.sections.each do |section|
            orders = []
            section.sortings.each do |sorting|
                orders << sorting.order
            end
            mode = section.calculate_mode(orders)
            average = section.calculate_average(orders)
            if section.sorting_information.nil?
                @sorting_info = SortingInformation.new(most_frequent: mode, average: average, section_id: section.id)        
                @sorting_info.save
            else
                section.sorting_information.update_attributes(most_frequent: mode, average: average)
            end
        end
        head :ok
    end

    def create_import_instagram
        @user = current_user
        photos = []
        pay_photos = []
        respond_to do |format| 
            if  Photo.tmp_photos(@user.id).count >= 10
                params[:photos].each { |image_url|
                    @photo = Photo.new(file: URI.parse(image_url), user_id: @user.id)
                    @photo.save
                    photos << @photo
                }
                photo_ids_array = photos.pluck(:id)
                photo_array_string = photo_ids_array.join("-")
                cookies[:pay_photos] = { value: photo_array_string, expires: 23.hours.from_now }
                format.html { redirect_to pay_upload_process_path, alert: 'You have reached the amount of free images' }
            else 
                params[:photos].each { |image_url|
                    @photo = Photo.new(file: URI.parse(image_url), user_id: current_user.id)        
                    @photo.save
                    photos << @photo
                }
                number_photos = (10 - Photo.tmp_photos(@user.id).count)

                if  photos.count <= number_photos
                    photo_ids_array = photos.pluck(:id)
                    first_photo_id = photo_ids_array.shift
                    photo_array_string = photo_ids_array.join("-")
                    cookies[:import_queue] = { value: photo_array_string, expires: 23.hours.from_now }
                    cookies[:first_imported_photo_id] = { value: first_photo_id, expires: 23.hours.from_now }

                    format.html { 
                        redirect_to edit_photo_path(first_photo_id), notice: 'Photo was successfully created.'
                    }
                else
                    photo_ids_array = photos.pluck(:id)
                    photo_array_string = photo_ids_array.join("-")
                    cookies[:import_queue] = { value: photo_array_string, expires: 23.hours.from_now }
                    format.html { redirect_to select_photos_path, alert: 'You have reached the amount of free images' }
                end
            end
        end
    end

    def create_import_facebook
       @user = current_user
        photos = []
        pay_photos = []
        respond_to do |format| 
            if  Photo.tmp_photos(@user.id).count >= 10
                params[:photos].each { |image_url|
                    @photo = Photo.new(file: URI.parse(image_url), user_id: @user.id)
                    @photo.save
                    photos << @photo
                }
                photo_ids_array = photos.pluck(:id)
                photo_array_string = photo_ids_array.join("-")
                cookies[:pay_photos] = { value: photo_array_string, expires: 23.hours.from_now }
                format.html { redirect_to pay_upload_process_path, alert: 'You have reached the amount of free images' }
            else 
                params[:photos].each { |image_url|
                    @photo = Photo.new(file: URI.parse(image_url), user_id: current_user.id)        
                    @photo.save
                    photos << @photo
                }
                number_photos = (10 - Photo.tmp_photos(@user.id).count)

                if  photos.count <= number_photos
                    photo_ids_array = photos.pluck(:id)
                    first_photo_id = photo_ids_array.shift
                    photo_array_string = photo_ids_array.join("-")
                    cookies[:import_queue] = { value: photo_array_string, expires: 23.hours.from_now }
                    cookies[:first_imported_photo_id] = { value: first_photo_id, expires: 23.hours.from_now }

                    format.html { 
                        redirect_to edit_photo_path(first_photo_id), notice: 'Photo was successfully created.'
                    }
                else
                    photo_ids_array = photos.pluck(:id)
                    photo_array_string = photo_ids_array.join("-")
                    cookies[:import_queue] = { value: photo_array_string, expires: 23.hours.from_now }
                    format.html { redirect_to select_photos_path, alert: 'You have reached the amount of free images' }
                end
            end
        end
    end

    def shared_times
        count = @photo.shared_times
        @photo.update_attributes(shared_times: (count + 1))
        redirect_to profile_show_path
    end

    # GET /photos/1
    # GET /photos/1.json
    def show
        @width, @height = @photo.dimensions 

        @photo = Photo.find(params[:id])
        seens = []
        @photo.seens.each do |seen|
            seens << seen.user_id
        end
        @seen = seens.include?(current_user.id)
    end

    # GET /photos/new
    def new
        if user_signed_in?
            @user = current_user
        else
            @user = current_affiliate
        end
        @photo = Photo.new
    end

    # GET /photos/1/edit
    def edit
        if !(@photo.user == current_user)
            respond_to do |format|
                format.html { redirect_to root_path, notice: "You can't edit other user's photos" }
            end
        end
    end

    def load_sections_to_sort
        @photo = Photo.find(params[:photo_id])

        respond_to do |format|
            format.json { render json: { sections: @photo.sections }, status: :ok }
        end
    end

    def edit_sections
        @photo = Photo.find(params[:photo_id])
        if @photo.user != current_user
            respond_to do |format|
                format.html{ redirect_to root_path, alert: "You can't edit other users sections"}
            end
        elsif !@photo.first_edit && @photo.draft == false
            respond_to do |format|
                format.html{ redirect_to root_path, alert: "You can't edit a photo's sections more than once"}
            end
        end
    end

    def load_sections_tracker
        @photo = Photo.find(params[:photo_id])
    end

    def save_sections
        @photo = Photo.find(params[:photo_id])
        if @photo.first_edit == true
            @photo.first_edit = false
            @photo.save  
        end
        if @photo.first_edit == false && @photo.draft == true
            @photo.sections.each do |section|
                section.destroy
            end
        end
        
        params[:sections].each_with_index do |section, i|
            @section = Section.new(photo_id: @photo.id, index: (i.to_i+1), top: section[1]["top"], left:section[1]["left"], width:section[1]["width"], height: section[1]["height"],translateX: section[1]["translateX"], translateY: section[1]["translateY"])        
            @section.save
        end
        head :ok
    end

    # POST /photos
    # POST /photos.json
    def create
        if user_signed_in?
            @user = current_user
        else
            @user = current_affiliate
        end
        @photo = Photo.new(photo_params)
        @photo.user = @user
        @photo.tmp = false
        respond_to do |format|
            if verify_recaptcha(model: @photo) && @photo.save
                if Photo.tmp_photos(@user.id).count > 10
                    @photo.update_attributes tmp: true
                    pay_photo_ids_array = @photo.id
                    pay_photo_array_string = pay_photo_ids_array
                    cookies[:tmp_pay_photos] = { value: pay_photo_array_string, expires: 23.hours.from_now }
                end
                format.html { redirect_to photo_edit_sections_path(photo_id: @photo.id), notice: 'Photo was successfully uploaded. Time to set your photo sections.' }
                format.json { render :show, status: :created, location: @photo }
            else
                format.html { render :new }
                format.json { render json: @photo.errors, status: :unprocessable_entity }
            end
        end
    end

    def edit_photos
        respond_to do |format|
            photo_ids_array = params[:photo_ids]
            first_photo_id = photo_ids_array.shift
            photo_array_string = photo_ids_array.join("-")
            cookies[:import_queue] = { value: photo_array_string, expires: 23.hours.from_now }

            format.html { redirect_to edit_photo_path(first_photo_id) }  
        end
    end

    # PATCH/PUT /photos/1
    # PATCH/PUT /photos/1.json
    def update
        @user = current_user
        respond_to do |format|
            if @photo.update(photo_params)
                if !cookies[:first_imported_photo_id].nil?
                    photo_id = cookies[:first_imported_photo_id]
                    cookies.delete(:first_imported_photo_id)
                    if @photo.first_edit
                        format.html { redirect_to photo_edit_sections_path(photo_id: photo_id.to_i), notice: 'Photo was successfully updated, now add the sections of your photo.' }
                    else
                        format.html { redirect_to edit_photo_path(photo_id.to_i), notice: 'Photo was successfully updated.' }
                    end
                elsif !cookies[:import_queue].empty?
                    photo_ids_array = cookies[:import_queue].split("-")
                    photo_id = photo_ids_array.shift
                    photo_array_string = photo_ids_array.join("-")
                    cookies[:import_queue] = { value: photo_array_string, expires: 23.hours.from_now }
                    
                    if @photo.first_edit
                        format.html { redirect_to photo_edit_sections_path(photo_id: photo_id.to_i), notice: 'Photo was successfully updated, now add the sections of your photo.' }
                    else
                        format.html { redirect_to edit_photo_path(photo_id.to_i), notice: 'Photo was successfully updated.' }
                    end
                else
                    format.html { redirect_to profile_show_path, notice: 'Photo was successfully updated' }
                end
            else
                format.html { render :edit }
                format.json { render json: @photo.errors, status: :unprocessable_entity }
            end
        end
    end

    def upload_process
        @user = current_user
        respond_to do |format|
            if !cookies[:tmp_pay_photos].empty?
                photo_ids_array = cookies[:tmp_pay_photos].split("-")
                photo_array_string = photo_ids_array.join("-")
                cookies[:pay_photos] = { value: photo_array_string, expires: 23.hours.from_now }

                cookies[:tmp_pay_photos] = ""
                format.html { redirect_to pay_upload_process_path, alert: 'You have reached the amount of free images' }  
            else
                format.html { redirect_to profile_show_path, notice: 'Photo was successfully updated' }
            end
        end
    end
    # DELETE /photos/1
    # DELETE /photos/1.json
    def destroy
        @photo.destroy
        cookies.delete(:photos_queue)
        respond_to do |format|
            format.html { redirect_to profile_show_path, notice: 'Photo was successfully deleted.' }
            format.json { head :no_content }
        end
    end

    def destroy_photos
        Photo.where(:id => params[:photo_ids]).destroy_all
        cookies.delete(:photos_queue)
        respond_to do |format|
            format.html { redirect_to profile_show_path, notice: 'Photos were successfully deleted.' }
            format.json { head :no_content }
        end
    end

    def suspend
        @photo = Photo.find(params[:id])
        @photo.update_attributes(suspended: true)
        respond_to do |format|
            ModelMailer.suspend_photo(@photo).deliver
            format.html { redirect_to admin_photos_path, notice: 'Photo was suspended.' }
            format.json { head :no_content }
        end
    end

    def approve
        @photo = Photo.find(params[:id])
        @photo.update_attributes(suspended: false, count_flags: 0)
        respond_to do |format|
            ModelMailer.approve_photo(@photo).deliver
            format.html { redirect_to admin_photos_path, notice: 'Photo was Approved.' }
            format.json { head :no_content }
        end
    end

    def like
        @photo.liked_by current_user
        respond_to do |format|
            format.html { redirect_to :back }
            format.js { render layout: false }
        end
    end

    def unlike
        @photo.unliked_by current_user
        respond_to do |format|
            format.html { redirect_to :back }
            format.js { render layout: false }
        end
    end

    def recent_sorts
        @photos = []
        @user = current_user

        case params[:filter_by].to_i
        when 1
            seens = Seen.get_sort_today(@user.id)
            seens.each do |seen|
                @photos << seen.photo
            end
        when 2
            seens = Seen.get_sort_this_week(@user.id)
            seens.each do |seen|
                @photos << seen.photo
            end
        when 3
            seens = Seen.get_sort_this_month(@user.id)
            seens.each do |seen|
                @photos << seen.photo
            end
        when 4
            seens = Seen.get_sort_last_ninety_days(@user.id)
            seens.each do |seen|
                @photos << seen.photo
            end
        else
            seens = Seen.get_sort_last_twenty_four_hours(@user.id)
            seens.each do |seen|
                @photos << seen.photo
            end        
        end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo
        @photo = Photo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_params
        params.require(:photo).permit(:description, :file, { tag_list: [] }, :user_id, :tmp)
    end
end
