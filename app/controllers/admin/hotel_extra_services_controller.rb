class Admin::HotelExtraServicesController < Admin::ApplicationController
  before_action :init_hotel

  def index
    @extra_services = @hotel.extra_services
    .where(permited_params[:where])
    .order((params[:order]||{id: :desc}))
    .page(params[:page]).per(params[:per_page])
    @extra_services = @extra_services.none unless can?(:index, Hotel)

    respond_with(@extra_services)
  end

  def show
  end

  def new
    authorize! :create, @hotel

    @extra_service = model.new

    render :show
  end

  def create
    authorize! :create, @hotel

    @extra_service = model.new
    @extra_service.attributes = params[:hotel_extra_service].permit!
    @extra_service.editor = current_user

    @extra_service.save

    render :show
  end

  def edit
    authorize! :edit, @hotel

    render :show
  end

  def update
    authorize! :edit, @hotel
    @extra_service.attributes = params[:hotel_extra_service].permit!

    @extra_service.editor = current_user

    @success = @extra_service.save

    respond_to do |format|
      format.html { render :show  }
      format.json { render json: { status: @success } }
    end
  end

  def delete
  end

  def destroy
    @extra_service.destroy
    render :show
  end

  private

  def init_hotel
    @hotel = Hotel.friendly_acquire params[:hotel_id]
    @extra_service = model.find params[:id] if params[:id]
  end
end
