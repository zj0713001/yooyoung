class Admin::HotelPackagesController < Admin::ApplicationController
  before_action :init_hotel

  def show
  end

  def new
    authorize! :create, @hotel

    @package = model.new(favorite: params[:favorite])
    @package.items.build(sequence: 1)

    render :show
  end

  def create
    authorize! :create, @hotel

    @package = model.new
    @package.attributes = params[:hotel_package].permit!
    @package.rooms = @hotel.rooms
    @package.editor = current_user

    @package.save

    render :show
  end

  def edit
    authorize! :edit, @hotel
    @package.items.build(sequence: 1)

    render :show
  end

  def update
    authorize! :edit, @hotel

    @package.attributes = params[:hotel_package].permit!
    @package.rooms = @hotel.rooms
    @package.editor = current_user

    @success = @package.save

    respond_to do |format|
      format.html { render :show  }
      format.json { render json: { status: @success } }
    end
  end

  def delete
  end

  def destroy
  end

  private

  def init_hotel
    @hotel = Hotel.friendly_acquire params[:hotel_id]
    @package = model.find params[:id] if params[:id]
  end
end
