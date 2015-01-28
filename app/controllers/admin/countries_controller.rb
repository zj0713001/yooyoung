class Admin::CountriesController < Admin::ApplicationController
  def index
    @countries = model
    .where(permited_params[:where])
    .order((params[:order]||{id: :desc}))
    .page(params[:page]).per(params[:per_page])
    @countries = @countries.none unless can?(:index, model)

    respond_with(@countries)
  end

  def show
    authorize! :show, model

    @country = model.acquire params[:id]
  end

  def new
    authorize! :create, model

    @country = model.new

    render :show
  end

  def create
    authorize! :create, model

    @country = model.new
    @country.editor = current_user
    @country.attributes = params[:country].permit!
    @country.save

    render :show
  end

  def edit
    authorize! :edit, model

    @country = model.acquire params[:id]

    render :show
  end

  def update
    @country = model.acquire params[:id]
    if params[:published].nil?
      authorize! :edit, model
      @country.attributes = params[:country].permit!
    else
      authorize! :publish, model
      @country.attributes = { published: params[:published] }
    end
    @country.editor = current_user

    @success = @country.save

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
