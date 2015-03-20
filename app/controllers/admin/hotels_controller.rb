class Admin::HotelsController < Admin::ApplicationController
  def index
    @hotels = model
    ._where(permited_params[:where])
    ._order((params[:order]||{id: :desc}))
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
    @hotel.package.items.build(sequence: @hotel.package.items.count+1)
    @hotel.package.rooms.build
    @hotel.build_favorite_package(favorite: true)
    @hotel.favorite_package.items.build(sequence: @hotel.favorite_package.items.count+1)

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

    # TODO
    @hotel.package.try(:rooms).to_a.each do |room|
      room.try(:save)
    end

    render :show
  end

  def edit
    authorize! :edit, model

    @hotel = model.friendly_acquire params[:id]
    @hotel.build_package if @hotel.package.blank?
    @hotel.package.items.build(sequence: @hotel.package.items.count+1)
    @hotel.package.rooms.build
    @hotel.build_favorite_package(favorite: true) if @hotel.favorite_package.blank?
    @hotel.favorite_package.items.build(sequence: @hotel.favorite_package.items.count+1)

    render :show
  end

  def update
    @hotel = model.friendly_acquire params[:id]
    if params[:published].nil?
      authorize! :edit, model
      @hotel.attributes = params[:hotel].permit!
      rooms = @hotel.package.try(:rooms).to_a
      @hotel.favorite_package.rooms = rooms
    else
      authorize! :publish, model
      @hotel.attributes = { published: params[:published] }
    end
    @hotel.editor = current_user

    @success = @hotel.save

    # TODO
    @hotel.package.try(:rooms).to_a.each do |room|
      room.try(:save)
    end

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
