class Admin::HotelsController < Admin::ApplicationController
  def index
    @hotels = model
    .where(params[:where].to_h.slice(*%w[id]))
    .order((params[:order]||{id: :desc}))
    .paginate(page: params[:page], per_page: params[:per_page])
    @hotels = @hotels.none unless can?(:index, model)
    respond_with(@hotels)
  end

  def show
    authorize! :show, model

    @hotel = model.acquire params[:id]
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
    @hotel.attributes = params[:hotel].permit!
    @hotel.editor = current_user
    rooms = @hotel.package.try(:rooms).to_a
    @hotel.favorite_package.rooms = rooms
    @hotel.save

    render :show
  end

  def edit
    authorize! :edit, model

    @hotel = model.acquire params[:id]
    @hotel.build_package if @hotel.package.blank?
    @hotel.package.items.build
    @hotel.package.rooms.build
    @hotel.build_favorite_package(favorite: true) if @hotel.favorite_package.blank?
    @hotel.favorite_package.items.build

    render :show
  end

  def update
    @hotel = model.acquire params[:id]
    if params[:published].nil?
      authorize! :edit, model
      @hotel.attributes = params[:hotel].permit!
      @hotel.editor = current_user

      @hotel.package.rooms = @hotel.favorite_package.rooms if @hotel.favorite_package.try(:rooms).present?
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
