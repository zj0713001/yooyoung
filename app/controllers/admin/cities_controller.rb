class Admin::CitiesController < Admin::ApplicationController
  def index
    @cities = model
    ._where(permited_params[:where])
    ._order((params[:order]||{id: :desc}))
    .includes(:country, :province)
    .page(params[:page]).per(params[:per_page])
    @cities = @cities.none unless can?(:index, model)

    respond_with(@cities)
  end

  def show
    authorize! :show, model

    @city = model.acquire params[:id]
  end

  def new
    authorize! :create, model

    @city = model.new

    render :show
  end

  def create
    authorize! :create, model

    @city = model.new
    @city.editor = current_user
    @city.attributes = params[:city].permit!
    @city.country = @city.province.try(:country) if @city.province
    @city.save

    render :show
  end

  def edit
    authorize! :edit, model

    @city = model.acquire params[:id]

    render :show
  end

  def update
    @city = model.acquire params[:id]
    if params[:published].nil?
      authorize! :edit, model
      @city.attributes = params[:city].permit!
      @city.country = @city.province.try(:country) if @city.province
    else
      authorize! :publish, model
      @city.attributes = { published: params[:published] }
    end
    @city.editor = current_user

    @success = @city.save

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
