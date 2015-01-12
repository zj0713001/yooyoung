class Admin::HotelsController < Admin::ApplicationController
  def index
    @hotels = model
    .where(params[:where].to_h.slice(*%w[id]))
    .order((params[:order]||{'id'=>:desc}).slice(*%w[id]))
    .paginate(page: params[:page], per_page: params[:per_page])
    @hotels = @hotels.none unless can?(:index, model) || @hotels.total_entries <= 1
    respond_with(@users)
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

    render :show
  end

  def edit
    @hotel = model.acquire params[:id]

    render :show
  end

  def update
  end

  def delete
  end

  def destroy
  end
end
