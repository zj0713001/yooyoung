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
    @hotel = model.acquire params[:id]
  end

  def new
    @hotel = model.new
    @hotel.build_package
    @hotel.package.items.build
    @hotel.build_favorite_package(favorite: true)
    @hotel.favorite_package.items.build
    @hotel.favorite_package.rooms.build

    render :show
  end

  def create
    @hotel = model.new
    @hotel.attributes = params[:hotel].permit!
    @hotel.editor = current_user

    @hotel.package.rooms = @hotel.favorite_package.rooms if @hotel.favorite_package.try(:rooms).present?
    @hotel.save

    render :show
  end

  def edit
    @hotel = model.acquire params[:id]

    render :show
  end

  def update
    @hotel = model.acquire params[:id]
    if params[:published].nil?
      @hotel.attributes = params[:hotel].permit!
      @hotel.editor = current_user

      @hotel.package.rooms = @hotel.favorite_package.rooms if @hotel.favorite_package.try(:rooms).present?
    else
      @hotel.attributes = { published: params[:published] }
    end

    @success = @hotel.save

    respond_to do |format|
      format.html { render :show }
      format.json { render json: { status: @success } }
    end
  end

  def delete
  end

  def destroy
  end
end
