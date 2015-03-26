class Admin::HotelPackagesController < Admin::ApplicationController
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

  private

  def init_hotel
    @hotel = Hotel.friendly_acquire params[:hotel_id]
  end
end
