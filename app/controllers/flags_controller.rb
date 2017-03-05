class FlagsController < ApplicationController
	before_action :authenticate_user!

  def create
    @photo = Photo.find(params[:photo_id])
    @flag = Flag.new(reason: params[:reason])
    @flag.user = current_user
    @flag.photo_id = @photo.id

    respond_to do |format|
      if @photo.user != current_user
        if verify_recaptcha(model: @flag)
          if @flag.save
            @photo.update_attributes(count_flags: @photo.count_flags + 1)
            if @photo.count_flags > 2
              @photo.update_attributes(suspended: true)
              ModelMailer.suspend_photo(@photo).deliver
            end
            format.html { redirect_to root_path, notice: 'flag was successfully created.' }
            format.json { render :show, status: :created, location: @flag}
          else
            format.html { redirect_to root_path, alert: 'Complete the Reason' }
            format.json { render json: @flag.errors, status: :unprocessable_entity }  
          end
        else
          format.html { redirect_to root_path, alert: 'Verify Recaptcha' }
          format.json { render json: @flag.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to root_path, alert: "You can't flag your own photo" }
      end
    end
  end
end
