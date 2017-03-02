class JustificationsController < ApplicationController
	before_filter :authenticate_user!

  def new
    @flags = Photo.find(params[:photo_id]).flags
    @justification = Justification.new
  end

	def create
		@user = current_user
    @justification = Justification.new(justification_params)
    @justification.user = @user
    @justification.photo_id = params[:photo_id]

    respond_to do |format|
      if @justification.save
        format.html { redirect_to root_path, notice: 'Successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @justification.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def justification_params
      params.require(:justification).permit(:title, :body, :user, :photo)
    end
end

