class PhotosController < ApplicationController
  before_action :set_photo, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, except: [:show, :index]

    # GET /photos
    # GET /photos.json
    def index
        @user = current_user
        #@photos = Photo.paginate(page: params[:page], per_page: 1).photos_sorting(@user.id)
    end

    def load_photo_to_sort
        respond_to do |format|
            @photo = Photo.find(params[:photo_id])
            if @photo.seen?
                format.html { redirect_to path, error: "You can't sort already seen images." }
            else
                format.js
            end
        end
    end

    def reaload_photos_queue
        if cookies[:photos_queue].empty?
            cookies[:photos_queue] = { value: Photo.photos_sorting(current_user.id).limit(5).pluck(:id), expires: 1.day }
            head status: :ok
        else
            head status: 500
        end
    end

    def update_photo_to_sorted_state
        @photo = Photo.find(params[:photo_id])
        @photo.update_attribute 'seen', true
        head status: :ok
    end

  def create_import_instagram
    if params[:photos]
      params[:photos].each { |image_url|
        @photo = Photo.new(file: URI.parse(image_url), user_id: current_user.id)        
        @photo.save
      }
    end
    respond_to do |format|
        format.html { redirect_to profile_show_path, notice: 'Photo was successfully created.' }
    end
  end

  def create_import_facebook
    if params[:photos]
      params[:photos].each { |image_url|
        @photo = Photo.new(file: URI.parse(image_url), user_id: current_user.id)        
        @photo.save
      }
    end
    respond_to do |format|
        format.html { redirect_to profile_show_path, notice: 'Photo was successfully created.' }
    end
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
        format.html { redirect_to @photo, notice: 'Photo was successfully updated.' }
        format.json { render :show, status: :ok, location: @photo }
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
      format.html { redirect_to photos_url, notice: 'Photo was successfully destroyed.' }
      format.json { head :no_content }
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
