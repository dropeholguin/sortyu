class FlagsController < ApplicationController
	before_action :authenticate_user!

  def create
    @photo = Photo.find(params[:photo_id])
    @flag = Flag.new(reason: params[:reason])
    @flag.user = current_user
    @flag.photo_id = @photo.id

    respond_to do |format|
      if @photo.user != current_user
        if verify_recaptcha(model: @flag) && @flag.save
          format.html { redirect_to root_path, notice: 'flag was successfully created.' }
          format.json { render :show, status: :created, location: @flag}
        else
          format.html { render :new }
          format.json { render json: @flag.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to root_path, alert: "You can't flag your own photo" }
      end
    end
  end
end
