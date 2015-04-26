class Admin::HotelFeaturesController < Admin::ApplicationController
  before_action :init_hotel

  def index
    @features = @hotel.features
    .where(permited_params[:where])
    .order((params[:order]||{sequence: :desc}))
    .page(params[:page]).per(params[:per_page])
    @features = @features.none unless can?(:index, Hotel)

    respond_with(@features)
  end

  def show
  end

  def new
    authorize! :create, @hotel

    @feature = model.new

    render :show
  end

  def create
    authorize! :create, @hotel

    @feature = model.new
    @feature.attributes = params[:hotel_feature].permit!
    @feature.editor = current_user

    @feature.save

    render :show
  end

  def edit
    authorize! :edit, @hotel

    render :show
  end

  def update
    authorize! :edit, @hotel
    @feature.attributes = params[:hotel_feature].permit!
    @feature.editor = current_user

    @success = @feature.save

    respond_to do |format|
      format.html { render :show  }
      format.json { render json: { status: @success } }
    end
  end

  def delete
  end

  def destroy
    @feature.destroy
    render :show
  end

  private

  def init_hotel
    @hotel = Hotel.friendly_acquire params[:hotel_id]
    @feature = model.find params[:id] if params[:id]
  end
end
