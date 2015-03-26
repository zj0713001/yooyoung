class Admin::RoomsController < Admin::ApplicationController
  before_action :init_hotel

  def show
  end

  def create
  end

  def edit
  end

  def update
  end

  def delete
  end

  def destroy
  end
  # def update
  #   @room = model.find params[:id]
  #   authorize! :edit, Hotel
  #
  #   @room.attributes = params[:room].permit!
  #   @success = @room.save
  #
  #   respond_to do |format|
  #     format.json { render json: { status: @success } }
  #   end
  #
  # end

  private

  def init_hotel
    @hotel = Hotel.friendly_acquire params[:hotel_id]
  end
end
