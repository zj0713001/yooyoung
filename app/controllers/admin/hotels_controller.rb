class Admin::HotelsController < Admin::ApplicationController
  def index
    @hotels = model
    .where(params[:where].to_h)
    .order((params[:order]||{id: :desc}))
    .page(params[:page]).per(params[:per_page])
    @hotels = @hotels.none unless can?(:index, model)

    respond_with(@hotels)
  end

  def show
    authorize! :show, model

    @hotel = model.friendly_acquire params[:id]
  end

  def new
    authorize! :create, model

    @hotel = model.new
    @hotel.build_package
    @hotel.package.items.build
    @hotel.package.rooms.build
    @hotel.build_favorite_package(favorite: true)
    @hotel.favorite_package.items.build

    render :show
  end

  def create
    authorize! :create, model

    @hotel = model.new
    @hotel.editor = current_user
    @hotel.attributes = params[:hotel].permit!
    rooms = @hotel.package.try(:rooms).to_a
    @hotel.favorite_package.rooms = rooms
    @hotel.save

    render :show
  end

  def edit
    authorize! :edit, model

    @hotel = model.friendly_acquire params[:id]
    @hotel.build_package if @hotel.package.blank?
    @hotel.package.items.build
    @hotel.package.rooms.build
    @hotel.build_favorite_package(favorite: true) if @hotel.favorite_package.blank?
    @hotel.favorite_package.items.build

    render :show
  end

  def update
    @hotel = model.friendly_acquire params[:id]
    if params[:published].nil?
      authorize! :edit, model
      @hotel.editor = current_user
      @hotel.attributes = params[:hotel].permit!
      rooms = @hotel.package.try(:rooms).to_a
      @hotel.favorite_package.rooms = rooms
    else
      authorize! :publish, model
      @hotel.attributes = { published: params[:published] }
    end

    @success = @hotel.save

    respond_to do |format|
      format.html { render :show }
      format.json { render json: { status: @success } }
    end
  end

  def delete
    authorize! :destroy, model
  end

  def destroy
    authorize! :destroy, model
  end
end
