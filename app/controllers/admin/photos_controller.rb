class Admin::PhotosController < Admin::ApplicationController
  def create
    @photo = Photo.new
    @photo.attributes = {
      image: params[:image],
      description: params[:description],
      editor: current_user,
    }

    if @photo.save
      respond_to do |format|
        format.json { render json: @photo, root: false }
      end
    else
      respond_to do |format|
        format.json { render json: { status: 'error' } }
      end
    end
  end

  def destroy
    @photo = Photo.find params[:id]
    @photo.destroy

    respond_with @photo
  end
end
