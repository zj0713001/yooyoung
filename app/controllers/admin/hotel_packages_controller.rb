class Admin::HotelPackagesController < Admin::ApplicationController
  before_action :init_hotel

  def index
    @packages = @hotel.packages
    .where(permited_params[:where])
    .order((params[:order]||{id: :desc}))
    .page(params[:page]).per(params[:per_page])
    @packages = @packages.none unless can?(:index, Hotel)

    respond_with(@packages)
  end

  def show
  end

  def new
    authorize! :create, @hotel

    @package = model.new
    @package.items.build(sequence: 1)

    render :show
  end

  def create
    authorize! :create, @hotel

    @package = model.new
    @package.attributes = params[:hotel_package].permit!
    @package.editor = current_user

    @package.save

    render :show
  end

  def edit
    authorize! :edit, @hotel

    render :show
  end

  def update
    authorize! :edit, @hotel
    if params[:published].nil?
      @package.attributes = params[:hotel_package].permit!
    else
      authorize! :publish, @hotel
      @package.attributes = { published: params[:published] }
    end

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
    @package.destroy
    render :show
  end

  private

  def init_hotel
    @hotel = Hotel.friendly_acquire params[:hotel_id]
    @package = model.find params[:id] if params[:id]
  end
end
