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

    def load_photo_to_sort
        respond_to do |format|
            @photo = Photo.find(params[:photo_id])
            if @photo.seen?
                format.html { redirect_to root_path, error: "You can't sort already seen images." }
            else
                format.js
            end
        end
    end

    def load_sorting_stats
        format.js
    end


    def reaload_photos_queue
        if cookies[:photos_queue].empty?
            photos = Photo.photos_sorting(current_user.id).order(state: :desc)
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
                flash[:error] = "You already saw all images."
                flash.keep(:notice)
                render js: "window.location = #{root_path.to_json}"
            else
                photo_array_string = photo_ids_array.join("-")
                cookies[:photos_queue] = { value: photo_array_string, expires: 23.hours.from_now }
                head :ok
            end
        else
            head 500
        end
    end

    def update_photo_to_sorted_state
        @photo = Photo.find(params[:photo_id])
        @seen = Seen.new(seen: true, user_id: current_user.id, photo_id: @photo.id)
        @seen.save
        head :ok
    end

    def create_sortings
        photo = Photo.find(params[:photo_id])
        if params[:sortings]
            params[:sortings].each_with_index do |sort, index|
                section = photo.sections.detect {|sect| sect.index == index }
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
        photos = []
        if params[:photos]
            params[:photos].each { |image_url|
                @photo = Photo.new(file: URI.parse(image_url), user_id: current_user.id)        
                @photo.save
                photos << @photo
            }
        end

        photo_ids_array = photos.pluck(:id)
        first_photo_id = photo_ids_array.shift
        photo_array_string = photo_ids_array.join("-")
        cookies[:import_queue] = { value: photo_array_string, expires: 23.hours.from_now }

        respond_to do |format|
            format.html { redirect_to edit_photo_path(first_photo_id), notice: 'Photo was successfully created.' }
        end
    end

    def create_import_facebook
        photos = []
        if params[:photos]
            params[:photos].each { |image_url|
                @photo = Photo.new(file: URI.parse(image_url), user_id: current_user.id)
                @photo.save
                photos << @photo
            }
        end

        photo_ids_array = photos.pluck(:id)
        first_photo_id = photo_ids_array.shift
        photo_array_string = photo_ids_array.join("-")
        cookies[:import_queue] = { value: photo_array_string, expires: 23.hours.from_now }

        respond_to do |format|
            format.html { redirect_to edit_photo_path(first_photo_id), notice: 'Photo was successfully created.' }
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
    end

    # GET /photos/new
    def new
        @photo = Photo.new
    end

    # GET /photos/1/edit
    def edit
    end

    # POST /photos
    # POST /photos.json
    def create
        @user = current_user
        @photo = @user.photos.new(photo_params)

        respond_to do |format|
            if @photo.save
                format.html { redirect_to profile_show_path, notice: 'Photo was successfully created.' }
                format.json { render :show, status: :created, location: @photo }
            else
                format.html { render :new }
                format.json { render json: @photo.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /photos/1
    # PATCH/PUT /photos/1.json
    def update
        respond_to do |format|
            if @photo.update(photo_params)
                if !cookies[:import_queue].empty?
                    photo_ids_array = cookies[:import_queue].split("-")
                    photo_id = photo_ids_array.shift
                    photo_array_string = photo_ids_array.join("-")
                    cookies[:import_queue] = { value: photo_array_string, expires: 23.hours.from_now }

                    format.html { redirect_to edit_photo_path(photo_id.to_i), notice: 'Photo was successfully updated.' }
                else
                    format.html { redirect_to profile_show_path, notice: 'Photo was successfully updated.' }
                end
            else
                format.html { render :edit }
                format.json { render json: @photo.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /photos/1
    # DELETE /photos/1.json
    def destroy
        @photo.destroy
        respond_to do |format|
            format.html { redirect_to profile_show_path, notice: 'Photo was successfully destroyed.' }
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

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo
        @photo = Photo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_params
        params.require(:photo).permit(:description, :file, :user_id)
    end
end
