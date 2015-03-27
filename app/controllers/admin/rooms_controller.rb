class Admin::RoomsController < Admin::ApplicationController
  before_action :init_hotel

  def show
  end

  def new
    authorize! :create, @hotel

    @room = model.new

    render :show
  end

  def create
    authorize! :create, @hotel

    @room = model.new
    @room.attributes = params[:room].permit!
    @room.editor = current_user

    @room.save

    render :show
  end

  def edit
    authorize! :edit, @hotel

    render :show
  end

  def update
    authorize! :edit, @hotel

    @room.attributes = params[:room].permit!
    @room.editor = current_user

    @success = @room.save

    respond_to do |format|
      format.html { render :show  }
      format.json { render json: { status: @success } }
    end
  end

  def delete
  end

  def destroy
    @room.destroy
    render :show
  end

  private

  def init_hotel
    @hotel = Hotel.friendly_acquire params[:hotel_id]
    @room = model.find params[:id] if params[:id]
  end
end
